@tool
class_name GrowthManager extends Node

@export var body: DinoBody
## Body length over level
@export var body_length: Curve
@export var neck: DinoNeck
## Neck length over level
@export var neck_length: Curve
@export var tail: DinoTail
## Tail length over level
@export var tail_length: Curve

const max_level: int = 999
@export_range(0.0, max_level) var preview_growth: float:
	set(value):
		preview_growth = value
		grow(value / max_level)

func grow(level: float) -> void:
	body.curr_length = body_length.sample(level)
	neck.curr_length = neck_length.sample(level)
	tail.curr_length = tail_length.sample(level)
