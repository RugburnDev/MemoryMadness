extends TextureButton

class_name GameTile

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var icon: TextureRect = $Icon
@onready var frame: TextureRect = $Frame
@onready var sound: AudioStreamPlayer = $Sound


var _icon_texture:Texture2D
var _frame_texture:Texture2D

func _ready() -> void:
	frame.texture = _frame_texture
	icon.texture = _icon_texture


func _equals(other: Variant) -> bool:
	print("_equals")
	if other is GameTile:
		print(_icon_texture == other._icon_texture, _icon_texture == other._icon_texture)
		return _icon_texture == other._icon_texture and _icon_texture == other._icon_texture
	return false
	

func setup(icon_texture:Texture2D, frame_texture:Texture2D) -> void:
	_icon_texture = icon_texture
	_frame_texture = frame_texture


func kill() -> void:
	z_index = 1
	animation_player.play("kill")


func return_face_down() -> void:
	animation_player.play("hide")
	disabled = false


func _on_pressed() -> void:
	disabled = true
	SoundManager.play_sound(sound, SoundManager.SOUND_SELECT_TILE)
	animation_player.play("reveal")
	SignalHub.emit_on_game_tile_pressed(self)


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "kill":
		disabled = true
