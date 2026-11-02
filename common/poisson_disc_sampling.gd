class_name PoissonDiscSampler extends Node

@export var radius: float
@export var sample_region_size: Vector2
@export var num_samples_before_rejection: int = 30

@export var noise: FastNoiseLite
@export var min_spacing := 30.0
@export var max_spacing := 120.0

# Dictionary of grid coordinate to index in the points list
var _grid: Dictionary[Vector2i, int]
var _points: Array[Vector2]
var _spawn_points: Array[Vector2]

var _cell_size: float = -1.0:
	get:
		return radius / sqrt(2.0)
var _grid_width: int:
	get:
		return int(sample_region_size.x / _cell_size)
var _grid_height: int:
	get:
		return int(sample_region_size.y / _cell_size)

func generate_points() -> Array[Vector2]:
	_spawn_points.append(sample_region_size / 2.0)
	while not _spawn_points.is_empty():
		var spawn_i: int = randi_range(0, len(_spawn_points)-1)
		var spawn_center: Vector2 = _spawn_points[spawn_i]
		var current_min_dist := _get_local_min_distance(spawn_center)
		var candidate_accepted: bool = false
		
		for i in range(num_samples_before_rejection):
			var random_dir: Vector2 = Vector2.from_angle(randf() * TAU)
			var random_dist: float = randf_range(current_min_dist, current_min_dist * 2.0)
			var candidate: Vector2 = spawn_center + random_dir * random_dist
			
			if _is_valid(candidate):
				var grid_pos: Vector2i = Vector2i(int(candidate.x / _cell_size), int(candidate.y / _cell_size))
				_grid[grid_pos] = len(_points)
				_points.append(candidate)
				_spawn_points.append(candidate)
				candidate_accepted = true
				break
			
		if not candidate_accepted:
			_spawn_points.remove_at(spawn_i)
	
	return _points

func _is_valid(candidate: Vector2) -> bool:
	if candidate.x < 0 or candidate.y < 0 or candidate.x > sample_region_size.x or candidate.y > sample_region_size.y:
		return false
		
	var grid_pos: Vector2i = Vector2i(int(candidate.x / _cell_size), int(candidate.y / _cell_size))
	var x_start: int = max(0, grid_pos.x-2)
	var x_end: int = min(grid_pos.x+2, _grid_width + 1)
	var y_start: int = max(0, grid_pos.y-2)
	var y_end: int = min(grid_pos.y+2, _grid_height + 1)
	
	for x in range(x_start, x_end):
		for y in range(y_start, y_end):
			var point_i = _grid.get(Vector2i(x, y))
			if not point_i:
				continue
			if candidate.distance_squared_to(_points[point_i]) < _get_local_min_distance(candidate) ** 2:
				return false
	
	return true

func _get_local_min_distance(pos: Vector2) -> float:
	var noise_val := noise.get_noise_2d(pos.x, pos.y)
	var t := remap(noise_val, -1.0, 1.0, 0.0, 1.0)
	return lerp(min_spacing, max_spacing, t)
