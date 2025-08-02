@tool
extends EditorScript

const PATH : String = "res://assets/glitch/"
const RES_PATH = "res://Resources/image_file_list.tres"

func _run() -> void:
	var dir : DirAccess = DirAccess.open(PATH)
	var ifr : ImageFileListResource = ImageFileListResource.new()

	if dir:
		var files : PackedStringArray = dir.get_files()
		for fn in files:
			ifr.add_file(PATH + fn)
		ResourceSaver.save(ifr, RES_PATH)
