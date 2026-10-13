class_name ExpManager extends Node

var curr_level: int = 1

func _ready() -> void:
	await get_tree().process_frame
	EventBus.level_up.emit(curr_level)

func handle_level_up() -> void:
	curr_level += 1
	EventBus.level_up.emit(curr_level)
