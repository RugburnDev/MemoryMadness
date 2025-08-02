extends Resource


class_name ImageFileListResource


@export var filenames : Array[String]


func add_file(filename:String) -> void:
	if not filename.ends_with(".import"):
		filenames.append(filename)
