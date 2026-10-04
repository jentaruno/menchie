@tool
class_name GrowthManager extends Node

## Body length over level
@export var body_length: Curve
@export var neck_length: Curve
@export var tail_length: Curve

@onready var _body: DinoBody = %Body
@onready var _neck: DinoNeck = %Neck
@onready var _tail: DinoTail = %Tail

@export_range(0.0, 1.0) var preview_growth: float:
	set(value):
		preview_growth = value
		grow(preview_growth)

func grow(level: float) -> void:
	_body.curr_length = body_length.sample(level)
	_neck.curr_length = neck_length.sample(level)
	_tail.curr_length = tail_length.sample(level)
