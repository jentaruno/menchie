class_name DinoHeadAnim extends Line2D

@export var normal_mouth_width: float = 0.54
@export var bite_mouth_width: float = 0.67
@export var bite_duration: float = 0.3

@onready var bite_particles: BiteParticle = %BiteParticles

var _curr_mouth_width: float
var _is_biting: bool = false

func _ready() -> void:
	_curr_mouth_width = normal_mouth_width
	_connect_parent()

func _physics_process(_delta: float) -> void:
	width_curve.set_point_value(1, _curr_mouth_width)

func bite() -> void:
	if _is_biting:
		return
	_is_biting = true
	_play_bite_animations()

func stop_bite() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "_curr_mouth_width", normal_mouth_width, bite_duration / 2.0)
	_is_biting = false

func _play_bite_animations() -> void:
	bite_particles.emit()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "_curr_mouth_width", bite_mouth_width, bite_duration / 2.0)
	tween.finished.connect(stop_bite)

func _connect_parent() -> void:
	z_index = owner.z_index + 1
	if not owner.has_user_signal("bite"):
		owner.add_user_signal("bite")
	owner.connect("bite", Callable(self, "bite"))
