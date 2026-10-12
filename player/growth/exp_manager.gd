class_name ExpManager extends Node

var curr_level: int = 1

func _ready() -> void:
	grow_to(curr_level)

func handle_level_up() -> void:
	curr_level += 1
	grow_to(curr_level)

func grow_to(level: int) -> void:
	Global.player.grow_to(level)
