extends Node

signal _on_game_exit_pressed
signal _on_level_selected(level:int)
signal _on_game_tile_pressed(tile:GameTile)
signal _on_game_over(moves:int, time:int)


func emit_on_game_tile_pressed(tile:GameTile) -> void:
	_on_game_tile_pressed.emit(tile)
	

func emit_on_level_selected(level:int) -> void:
	_on_level_selected.emit(level)
	
	
func emit_on_game_exit_pressed() -> void:
	_on_game_exit_pressed.emit()


func emit_on_game_over(moves:int, time:int) -> void:
	_on_game_over.emit(moves, time)
