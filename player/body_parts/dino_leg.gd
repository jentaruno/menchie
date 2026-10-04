class_name DinoLeg extends Node2D

var _step_target: Vector2 = Vector2.ZERO
var _step_speed: float = 0.0

func _physics_process(delta: float) -> void:
	if _step_speed:
		global_position = global_position.move_toward(_step_target, _step_speed * delta)
		if global_position == _step_target:
			_step_speed = 0.0
			Global.footstep_manager.step(global_position)

## Move along with the body
func move(delta: Vector2, move_rate: float) -> void:
	position += delta * move_rate

## Make this leg take a step forward
func step(target_global_pos: Vector2, speed: float) -> void:
	_step_target = target_global_pos
	_step_speed = speed

func is_stepping() -> bool:
	return bool(_step_speed)
