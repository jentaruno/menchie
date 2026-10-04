class_name BiteParticle extends Line2D

## Particles will fan out to +- this many degrees
@export_range(0, 360, 0.1, "degrees") var spread: float = 60
## Radius where particles will start spawning
@export var radius: float = 10.0
## Number of points for the curve
@export var num_points: int = 20

## Number of spikes
@export var num_spikes: int = 3
## Spike texture
@export var spike_texture: Texture2D = preload("res://particles/fan_particle.png")

## Color of bite particles
@export var particle_color: Color = Color.WHITE
## Duration for bite particles to fade in / fade out
@export var fade_duration: float = 0.1

func _ready() -> void:
	clear_points()
	_make_curve()
	_make_spikes()
	
func emit() -> void:
	var tween = _fade_tween(true)
	await tween.finished
	_fade_tween(false)

func _make_curve() -> void:
	for i in range(num_points + 1):
		var r_spread = deg_to_rad(spread)
		var angle = lerp(-r_spread, r_spread, float(i) / num_points)
		var dir = Vector2.RIGHT.rotated(angle)
		var p = position + dir * radius
		add_point(p)

func _make_spikes() -> void:
	var rot_unit = 2 * spread / (num_spikes + 1)
	for i in range(num_spikes):
		var spike = Sprite2D.new()
		spike.texture = spike_texture
		var angle = deg_to_rad(-spread + (i + 1) * rot_unit)
		var dir = Vector2.RIGHT.rotated(angle)
		var p = position + dir * radius
		spike.position = p
		spike.scale = Vector2(0.5, 0.5)
		spike.rotate(angle)
		add_child(spike)

func _fade_tween(fade_in: bool) -> Tween:
	var color = particle_color if fade_in else Color("ffffff00")
	var tween = create_tween()
	tween.tween_property(self, "modulate", color, fade_duration)
	return tween
