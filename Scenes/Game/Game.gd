extends Control

const GAME_TILE = preload("res://Scenes/GameTile/GameTile.tscn")
const ANIMATION_DELAY : float = 1.2

@onready var game_grid_container: GridContainer = $HBoxContainer/GameGridContainer
@onready var moves_actual: Label = $HBoxContainer/MenuMarginContainer/VBoxContainer/MovesHBox/MovesActual
@onready var pairs_actual: Label = $HBoxContainer/MenuMarginContainer/VBoxContainer/PairsHBox/PairsActual
@onready var sound: AudioStreamPlayer = $HBoxContainer/Sound
@onready var time_actual: Label = $HBoxContainer/MenuMarginContainer/VBoxContainer/HBoxContainer/TimeActual
@onready var timer: Timer = $HBoxContainer/Timer


var _level : int
var _level_settings : LevelSettingResource
var _rows : int
var _cols : int
var _pairs : int
var _selected_game_tiles : Array[GameTile]
var _moves : int = 0
var _matches : int = 0
var _paused_tiles : Array[GameTile]
var _time_elapsed : int


func _ready() -> void:
	SignalHub._on_level_selected.connect(_on_level_selected)
	SignalHub._on_game_tile_pressed.connect(_on_game_tile_pressed)
	_setup()

func _setup() -> void:
	for child in game_grid_container.get_children():
		child.queue_free()
	_update_time_display()

func _reset() -> void:
	_moves = 0
	_matches = 0
	_time_elapsed = 0
	_selected_game_tiles = []
	timer.paused = false
	_setup()
	
	
func _handle_miss() -> void:
	for _tile in _selected_game_tiles:
		_tile.return_face_down()
	_selected_game_tiles = []
	_log_move()
	

func _log_move() -> void:
	_moves += 1
	moves_actual.text = "%d" % _moves
	
func _log_match() -> void:
	_matches += 1
	pairs_actual.text = "%d/%d" % [_matches, _pairs]
	

func _handle_match() -> void:
	SoundManager.play_sound(sound, SoundManager.SOUND_SUCCESS)
	for _tile in _selected_game_tiles:
		_tile.kill()
	_selected_game_tiles = []
	_log_move()
	_log_match()
	

func _check_match(tiles: Array[GameTile]) -> bool:
	return tiles[0]._equals(tiles[1]) 
	

func _check_game_over() -> void:
	if _matches == _pairs:
		timer.paused = true
		SignalHub.emit_on_game_over(_moves, _time_elapsed)


func _deactivate_tiles() -> void:
	_paused_tiles = []
	for tile : GameTile in game_grid_container.get_children():
		if !tile.disabled:
			_paused_tiles.append(tile)
			tile.disabled = true


func _reactivate_tiles() -> void:
	for tile : GameTile in _paused_tiles:
		tile.disabled = false
	_paused_tiles = []


func _on_game_tile_pressed(tile:GameTile) -> void:
	_selected_game_tiles.append(tile)
	if _selected_game_tiles.size() == 2:
		_deactivate_tiles()
		await get_tree().create_timer(ANIMATION_DELAY).timeout
		if _check_match(_selected_game_tiles) == true:
			_handle_match()
		else:
			_handle_miss()
	_reactivate_tiles()
	_check_game_over()


func _on_level_selected(level:int) -> void:
	_reset()
	_level = level
	_level_settings = LevelDataSelector.get_level_setting(_level)
	_build_level()


func _build_level() -> void:
	_rows = _level_settings.get_rows()
	_cols = _level_settings.get_cols()
	@warning_ignore("integer_division")
	_pairs = (_cols * _rows) / 2
	game_grid_container.columns = _cols
	pairs_actual.text = "%d/%d" % [_matches, _pairs]
	_build_grid()
	
	
func _build_grid() -> void:
	var tiles : Array[GameTile] = []
	var pairs_remaining : int = _pairs
	
	while (pairs_remaining > 0):
		var frame_texture : Texture2D = ImageManager.get_random_frame()
		var icon_texture : Texture2D = ImageManager.get_random_image()
		for i in range(2):
			var new_tile : GameTile = GAME_TILE.instantiate()
			new_tile.setup(icon_texture, frame_texture)
			tiles.append(new_tile)
		pairs_remaining -= 1
	
	tiles.shuffle()
	for tile in tiles:
		game_grid_container.add_child(tile)


func _update_time_display() ->void:
	time_actual.text = "%d" % _time_elapsed

func _on_exit_button_pressed() -> void:
	SoundManager.play_button_click(sound)
	timer.paused = true
	SignalHub.emit_on_game_exit_pressed()


func _on_timer_timeout() -> void:
	_time_elapsed += 1
	_update_time_display()
