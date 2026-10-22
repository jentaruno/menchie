class_name DinoLegs extends Node2D

## Rate at which legs follow the body's position. 1 = fully following, 0 = not following at all
@export var body_follow_rate: float = 0.08

@onready var hind_legs = %HindLegsCenter
@onready var legs: Array[DinoLeg] = [
	%LeftFrontLeg,
	%LeftHindLeg,
	%RightFrontLeg,
	%RightHindLeg
]
@onready var leg_joints: Array[Marker2D] = [
	%LeftFrontLegJoint,
	%LeftHindLegJoint,
	%RightFrontLegJoint,
	%RightHindLegJoint
]

var _step_length: float = 3.0
var _leg_move_speed: float = 30.0
var _last_stepped_leg: int = 0
var _legs_to_step: Array[int]
var _is_stepping: bool = false

func _physics_process(_delta: float) -> void:
	_move_legs()
	if not _is_done_stepping():
		return
	_is_stepping = _maybe_step()

func init_legs(front_legs_pos: Vector2, hind_legs_pos: Vector2) -> void:
	global_position = front_legs_pos
	hind_legs.global_position = hind_legs_pos
	for i in range(legs.size()):
		legs[i].global_position = leg_joints[i].global_position

func grow(progress: float) -> void:
	_step_length = Constants.growth_config.leg_step_length.sample(progress)
	_leg_move_speed = Constants.growth_config.leg_move_speed.sample(progress)
	
	var curr_leg_scale = Constants.growth_config.leg_scale.sample(progress)
	leg_joints[0].position.y = -curr_leg_scale * Constants.growth_config.init_front_leg_joints_distance
	leg_joints[2].position.y = curr_leg_scale * Constants.growth_config.init_front_leg_joints_distance
	leg_joints[1].position.y = -curr_leg_scale * Constants.growth_config.init_hind_leg_joints_distance
	leg_joints[3].position.y = curr_leg_scale * Constants.growth_config.init_hind_leg_joints_distance
	for i in range(legs.size()):
		legs[i].scale = Vector2.ONE * curr_leg_scale

func is_stepping() -> bool:
	return _is_stepping
	
func _is_done_stepping() -> bool:
	for i in range(_legs_to_step.size()-1, -1, -1):
		var leg_index = _legs_to_step[i]
		if not legs[leg_index].is_stepping():
			_legs_to_step.remove_at(i)
	return _legs_to_step.is_empty()

func _move_legs() -> void:
	for i in range(legs.size()):
		var dir = leg_joints[i].global_position - legs[i].global_position
		legs[i].move(dir, body_follow_rate)

func _maybe_step() -> bool:
	var stepped = false
	for unwrapped_i in range(_last_stepped_leg, _last_stepped_leg + legs.size()):
		var i = unwrapped_i % legs.size()
		var leg_needs_step = legs[i].global_position.distance_to(leg_joints[i].global_position) > _step_length
		if not leg_needs_step:
			continue
		if _legs_to_step.is_empty():
			var target_dir = legs[i].global_position.direction_to(leg_joints[i].global_position)
			var target_pos = legs[i].global_position + target_dir * 2 * _step_length
			legs[i].step(target_pos, _leg_move_speed)
			_last_stepped_leg = i
			stepped = true
		_legs_to_step.append(i)
	return stepped
