extends Biteable

@onready var leaf_particles: PackedScene = preload("res://particles/leaf_particles.tscn")
@onready var tree_sprite: Sprite2D = %TreeSprite

@export_range(0.0, 360.0, 1.0, "degrees") var shake_skew: float = 5.0
@export var shake_duration: float = 0.5
@export var shake_scale: Vector2 = Vector2(0.8, 0.8)
## Distance between teeth and where leaf particles spawn
@export var leaf_particles_offset: float = 5.0

func on_bite(bite_pos: Vector2) -> void:
	_shake_tree()
	_emit_leaf_particles(bite_pos)

func _shake_tree() -> void:
	var skew_tween = TweenUtil.shake_skew(tree_sprite, shake_skew, shake_duration)
	skew_tween.set_parallel(true)
	var pop_tween = TweenUtil.pop(tree_sprite, shake_scale)
	pop_tween.set_parallel(true)

func _emit_leaf_particles(pos: Vector2) -> void:
	var particle_dir = pos.direction_to(global_position)
	var particles = leaf_particles.instantiate() as CPUParticles2D
	add_child(particles)
	particles.global_position = pos + particle_dir * leaf_particles_offset
	particles.global_rotation = particle_dir.angle()
	particles.finished.connect(particles.queue_free)
	particles.emitting = true
