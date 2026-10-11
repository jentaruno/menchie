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
var curr_level: int = 1

func _ready() -> void:
	grow_to(curr_level)

func grow_to(level) -> void:
	curr_level = level
	var x = float(curr_level) / max_level
	body.grow_to(body_length.sample(x))
	neck.grow_to(neck_length.sample(x))
	tail.grow_to(tail_length.sample(x))

func grow(level_amt: int = 1) -> void:
	curr_level += level_amt
	grow_to(curr_level)
