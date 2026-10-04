class_name DinoBody extends AttachableLine2D

## Movement speed
@export var move_speed: float = 50.0
## Slerp rate to smoothly turn toward input direction
@export_range(0.0, 360.0, 0.1, "degrees") var turn_speed: float = 0.9

@export_group("Bones")
@export var curr_length: float = 96.0:
	set(value):
		curr_length = value
		_init_bones()
## Number of bones in the body
@export var num_bones: int = 24:
	set(value):
		num_bones = value
		_init_bones()
## What bone index the neck attaches to
@export var neck_bone_index: int = 1
## What bone index the tail attaches to
@export var tail_bone_index: int = -1
## What bone index the hind legs attach to
@export var hind_legs_bone_index: int = -3
## What bone index the front legs attach to
@export var front_legs_bone_index: int = 1

#region Private variables
var _bones: Array[Vector2] = []
var _bone_length: float
var _body_dir: Vector2 = Vector2.RIGHT
var _last_input_dir: Vector2 = Vector2.ZERO
var _move_speed: float = 0.0
#endregion

#region References
@onready var neck: DinoNeck = %Neck
@onready var tail: DinoTail = %Tail
@onready var legs: DinoLegs = %Legs
#endregion

func _ready() -> void:
	Global.player_body = self
	_init_bones()
	_init_limbs()
	_connect_parent()

func _physics_process(delta: float) -> void:
	if _last_input_dir == Vector2.ZERO:
		return
		
	var step = _body_dir * _move_speed * delta
	owner.global_position += step
	
	_update_bones()
	_update_line2d()
	super(delta)

func move(delta: float, dir: Vector2) -> void:
	if legs.is_stepping():
		_move_speed = 0.0
		return
	_move_speed = move_speed
	_last_input_dir = dir
	_body_dir = _body_dir.slerp(dir.normalized(), turn_speed * delta)
	
func _update_bones() -> void:
	_bones[0] = global_position
	for i in range(1, num_bones):
		var dir = (_bones[i] - _bones[i-1]).normalized()
		_bones[i] = _bones[i -1] + dir * _bone_length
	
func _update_line2d() -> void:
	clear_points()
	for pos in _bones:
		add_point(to_local(pos))

func _init_bones() -> void:
	_bones.clear()
	_bone_length = curr_length / num_bones
	for i in range(num_bones):
		_bones.append(global_position - Vector2(_bone_length * i, 0.0))
	
	_update_line2d()

func _init_limbs() -> void:
	super.attach(neck, neck_bone_index)
	super.attach(tail, tail_bone_index, true, AttachableLine2D.RotationUpdate.NONE)
	super.attach(legs, front_legs_bone_index, true, AttachableLine2D.RotationUpdate.NONE)
	super.attach(legs.hind_legs, hind_legs_bone_index, true, AttachableLine2D.RotationUpdate.NONE)
	legs.init_legs(_bones[front_legs_bone_index], _bones[hind_legs_bone_index])

func _connect_parent() -> void:
	var move_args = [
		{"name": "delta", "type": TYPE_FLOAT},
		{"name": "dir", "type": TYPE_VECTOR2}
	]
	owner.add_user_signal("move", move_args)
	owner.connect("move", Callable(self, "move"))
