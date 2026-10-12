class_name DinoHead extends Area2D

var curr_collision: Object

func try_bite() -> void:
	var overlapping_areas = get_overlapping_areas()
	if overlapping_areas.is_empty():
		return
		
	for area in overlapping_areas:
		if area is Biteable:
			area.on_bite(%TeethMarker2D.global_position)
			break
