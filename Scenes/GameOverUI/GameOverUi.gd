extends Control

@onready var moves_actual: Label = $NinePatchRect/VBoxContainer/MovesHBox/MovesActual
@onready var time_actual: Label = $NinePatchRect/VBoxContainer/HBoxContainer/TimeActual


func _ready() -> void:
	pass # Replace with function body.


func _enter_tree() -> void:
	SignalHub._on_game_over.connect(_on_game_over)
	SignalHub._on_game_exit_pressed.connect(_on_game_exit_pressed)
	
	
func _on_game_over(moves:int, time:int) -> void:
	await get_tree().create_timer(1.0).timeout
	moves_actual.text = "%d" % moves
	time_actual.text = "%d" % time
	show()


func _on_game_exit_pressed() -> void:
	hide()
