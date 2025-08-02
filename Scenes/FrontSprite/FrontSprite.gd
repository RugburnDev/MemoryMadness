extends TextureRect

const SCALE_SMALL : Vector2 = Vector2(0.0, 0.0)
const SCALE_NORMAL : Vector2 = Vector2(1.0, 1.0)
const SCALE_TIME : float = 1.0



func _ready() -> void:
	_set_random_image()
	_run_tween()


func _set_random_image() -> void:
	texture = ImageManager.get_random_image()
	
	
func _get_random_time() -> float:
	return randf_range(1.0, 2.0)
	

func _get_random_rotation() -> float:
	return deg_to_rad(randf_range(-360.0, 360.0))

	
func _run_tween() -> void:
	var tween: Tween = create_tween()
	var time : float = _get_random_time()
	tween.set_loops()
	tween.tween_property(self, "scale", SCALE_SMALL, SCALE_TIME)
	tween.tween_callback(_set_random_image)
	tween.tween_property(self, "scale", SCALE_NORMAL, SCALE_TIME)
	tween.tween_property(self, "rotation", _get_random_rotation(), time)
	tween.tween_callback(_run_tween)
	
