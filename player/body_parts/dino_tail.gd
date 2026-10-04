class_name DinoTail extends Line2D

# Simulates tail movement by fitting a Line2D to a standing wave

var curr_length: float = 160.0:
	set(value):
		curr_length = value
		_initialize_bones()
@export var num_bones: int = 12:
	set(value):
		num_bones = value
		_initialize_bones()
@export var lambda: float = 256.0
@export var frequency: float = 0.5
@export var amplitude: float = 2.0

### Should the tail be moving?
#var moving: bool = false
### Keep track of current time for wave function
#var _time: float
### Wave number
#var _k: float
### Angular frequency
#var _omega: float

#region Private variables
var _bones: Array[Vector2] = []
var _bone_length: float
var _last_dir: Vector2
#endregion

func _ready() -> void:
	_initialize_bones()

func _physics_process(_delta: float) -> void:
	_update_bones()
	_update_line2d()

func move(dir: Vector2) -> void:
	_last_dir = dir.normalized()
	
func _update_bones() -> void:
	_bones[0] = global_position
	for i in range(1, num_bones):
		var dir = (_bones[i] - _bones[i-1]).normalized()
		_bones[i] = _bones[i -1] + dir * _bone_length
	
func _update_line2d() -> void:
	clear_points()
	for pos in _bones:
		add_point(to_local(pos))
		
func _initialize_bones() -> void:
	_bones.clear()
	_bone_length = curr_length / num_bones
	for i in range(num_bones):
		_bones.append(global_position - Vector2(_bone_length * i, 0.0))
	
	_update_line2d()
