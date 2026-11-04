class_name ObjectPlacementGenerator extends Node2D

@export var position_sampler: PoissonDiscSampler
@export var spawner: RandomTransformSpawner

func _ready() -> void:
	position_sampler.sample_region_size = get_parent().grid_world_size
	var points = position_sampler.generate_points()
	for point in points:
		spawner.spawn(global_position + point)
