class_name FootstepManager extends Node

var footstep_scene = preload("res://world/terrain/footstep.tscn")

func _ready() -> void:
	Global.footstep_manager = self
	EventBus.step_foot.connect(step)
	
func step(pos: Vector2) -> void:
	var footstep = footstep_scene.instantiate() as Footstep
	add_child(footstep)
	footstep.global_position = pos
