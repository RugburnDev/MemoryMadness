extends Node

const IMAGE_FILE_LIST_PATH = "res://Resources/image_file_list.tres"
const FRAME_IMAGES : Array[Texture2D] = [
	preload("res://assets/frames/green_frame.png"),
	preload("res://assets/frames/red_frame.png"),
	preload("res://assets/frames/yellow_frame.png"),
	preload("res://assets/frames/blue_frame.png")
]


var _image_list : Array[Texture2D]


func _enter_tree() -> void:
	var ifl : ImageFileListResource = ResourceLoader.load(IMAGE_FILE_LIST_PATH)
	for file in ifl.filenames:
		_image_list.append(load(file))


func get_random_image() -> Texture2D:
	return _image_list.pick_random()


func get_random_frame() -> Texture2D:
	return FRAME_IMAGES.pick_random()


func get_image_by_index(idx:int) -> Texture2D:
	return _image_list.get(idx)


func shuffle_images() -> void:
	_image_list.shuffle()
