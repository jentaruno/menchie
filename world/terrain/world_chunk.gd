@tool
extends Node2D

@export var cell_size: Vector2 = Vector2(32, 32):
	set(value):
		cell_size = value
		queue_redraw()
@export var grid_size: Vector2i = Vector2i(20, 15):
	set(value):
		grid_size = value
		queue_redraw()
@export var grid_color: Color = Color(1, 1, 1, 0.3):
	set(value):
		grid_color = value
		queue_redraw()
@export var show_debug_grid: bool = false:
	set(value):
		show_debug_grid = value
		queue_redraw()

var grid_world_size: Vector2:
	get:
		return Vector2(grid_size.x * cell_size.x, grid_size.y * cell_size.y)
	
func _draw() -> void:
	if not show_debug_grid:
		return
	
	var left = -grid_size.x / 2.0
	var right = grid_size.x / 2.0
	var top = -grid_size.y / 2.0
	var bottom = grid_size.y / 2.0
	
	for x in range(left * cell_size.x, (right + 1) * cell_size.x, cell_size.x):
		var line_start = Vector2(x, top * cell_size.y)
		var line_end = Vector2(x, bottom * cell_size.y)
		draw_line(line_start, line_end, grid_color)

	for y in range(top * cell_size.y, (bottom + 1) * cell_size.y, cell_size.y):
		var line_start = Vector2(left * cell_size.x, y)
		var line_end = Vector2(right * cell_size.x, y)
		draw_line(line_start, line_end, grid_color)
