extends Object

class_name LevelDataSelector

const LEVEL_DATA : LevelsDataResource = preload("res://Resources/LevelData.tres")

static func get_level_setting(level:int)-> LevelSettingResource:
	return LEVEL_DATA.get_level_data(level)
