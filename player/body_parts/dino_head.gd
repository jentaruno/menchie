extends Area2D

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
	
func _connect_parent() -> void:
	if not owner.has_user_signal("bite"):
		owner.add_user_signal("bite")
	owner.connect("bite", Callable(self, "try_bite"))
