class_name RandomTransformSpawner extends Node2D

@export var object: PackedScene
@export var min_scale: float = 1.0
@export var max_scale: float = 1.0
@export_range(0, 360, 0.1, "degrees") var min_rotation: float = 0.0
@export_range(0, 360, 0.1, "degrees") var max_rotation: float = 0.0

func spawn(pos: Vector2) -> void:
	var instance: Node2D = object.instantiate()
	add_child(instance)
	instance.global_position = pos
	instance.scale = Vector2.ONE * randf_range(min_scale, max_scale)
	instance.rotation_degrees = randf_range(min_rotation, max_rotation)
