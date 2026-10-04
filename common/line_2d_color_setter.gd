@tool
class_name Line2DColorSetter extends Node

@export var lines: Array[Line2D]
@export var color: Color:
	set(value):
		color = value
		_set_line_colors()

func _ready() -> void:
	_set_line_colors()

func _set_line_colors() -> void:
	for line in lines:
		line.default_color = color
