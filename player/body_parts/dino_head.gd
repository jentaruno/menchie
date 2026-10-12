class_name DinoHead extends Area2D

var curr_collision: Object

func _ready() -> void:
	_connect_parent()

func try_bite() -> void:
	var overlapping_areas = get_overlapping_areas()
	if overlapping_areas.is_empty():
		return
		
	for area in overlapping_areas:
		if area is Biteable:
			area.on_bite(%TeethMarker2D.global_position)
			break
		
func grow(progress: float) -> void:
	scale = Vector2.ONE * Constants.growth_config.head_scale.sample(progress)

func _connect_parent() -> void:
	if owner.has_signal("grew"):
		owner.connect("grew", Callable(self, "grow"))
