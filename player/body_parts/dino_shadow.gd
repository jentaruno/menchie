extends Node2D

@export var body_parts: Array[Line2D]
var _shadows: Array[Line2D]

func _ready() -> void:
	for part in body_parts:
		var part_shadow = Line2D.new()
		part_shadow.default_color = part.default_color
		part_shadow.width = part.width
		part_shadow.width_curve = part.width_curve
		part_shadow.begin_cap_mode = part.begin_cap_mode
		part_shadow.end_cap_mode = part.end_cap_mode
		add_child(part_shadow)
		_shadows.append(part_shadow)

func _process(_delta: float) -> void:
	for i in range(body_parts.size()):
		_shadows[i].global_position = body_parts[i].global_position
		_shadows[i].global_rotation = body_parts[i].global_rotation
		_shadows[i].points = body_parts[i].points.duplicate()
