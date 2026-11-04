@tool
class_name PoissonDiscSampler extends Node2D

@export var radius: float:
	set(value):
		radius = value
		queue_redraw()
@export var sample_region_size: Vector2:
	set(value):
		sample_region_size = value
		queue_redraw()
@export var num_samples_before_rejection: int = 30

@export var noise: FastNoiseLite:
	set(value):
		noise = value
		queue_redraw()
		
## Minimum value in the noise sample to spawn a tree
@export_range(0.0, 1.0) var spawn_threshold: float 

@export var min_spacing := 30.0
@export var max_spacing := 120.0
@export var show_debug_noise_samples: bool = false:
	set(value):
		show_debug_noise_samples = value
		queue_redraw()

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
		var candidate_accepted: bool = false
		
		for i in range(num_samples_before_rejection):
			var random_dir: Vector2 = Vector2.from_angle(randf() * TAU)
			var random_dist: float = randf_range(min_spacing, max_spacing)
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
	
	if _get_noise_value(candidate) < spawn_threshold:
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
			if candidate.distance_squared_to(_points[point_i]) < min_spacing ** 2:
				return false
	
	return true

func _draw() -> void:
	if not show_debug_noise_samples or noise == null or _cell_size <= 0.0:
		z_index = 0
		return
	
	z_index = -1
	var cell_size := Vector2.ONE * _cell_size
	for x in range(_grid_width):
		for y in range(_grid_height):
			var sample_pos := (Vector2(x, y) + Vector2.ONE * 0.5) * _cell_size
			var rect_pos := sample_pos - sample_region_size / 2.0 - cell_size / 2.0
			var value := _get_noise_value(sample_pos)
			draw_rect(Rect2(rect_pos, cell_size), Color(value, value, value))

func _get_noise_value(pos: Vector2) -> float:
	var noise_val := noise.get_noise_2d(pos.x, pos.y)
	return clampf(remap(noise_val, -1.0, 1.0, 0.0, 1.0), 0.0, 1.0)
