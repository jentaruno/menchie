class_name Footstep extends Sprite2D

## Seconds until the footstep fades away
@export var fade_time: float = 20.0

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_time)
