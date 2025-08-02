extends Control

@onready var music: AudioStreamPlayer = $Music
@onready var game: Control = $Game
@onready var main: Control = $Main



func _ready() -> void:
	_on_game_exit_pressed()
	
	
func _enter_tree() -> void:
	SignalHub._on_game_exit_pressed.connect(_on_game_exit_pressed)
	SignalHub._on_level_selected.connect(_on_level_selected)
	SignalHub._on_game_over.connect(_on_game_over)


func _on_level_selected(_level:int) -> void:
	SoundManager.play_sound(music, SoundManager.SOUND_IN_GAME)
	show_game(true)


func _on_game_exit_pressed() -> void:
	SoundManager.play_sound(music, SoundManager.SOUND_MAIN_MENU)
	show_game(false)
	

func _on_game_over(_moves:int, _time:int) -> void:
	SoundManager.play_sound(music, SoundManager.SOUND_GAME_OVER)


func show_game(s:bool) -> void:
	game.visible = s
	main.visible = !s
