class_name PlayerCamera extends Camera2D

## Camera lerp speed
@export var smoothing_speed: float = 2.0
## Maximum distance to look ahead of the player body
@export var max_lookahead_distance: float = 100.0

func _ready() -> void:
	Global.player_camera = self

func _physics_process(delta: float) -> void:
	var player_pos = Global.player_body.global_position
	var mouse_pos = get_global_mouse_position()
	var player_to_mouse = (mouse_pos - player_pos).limit_length(max_lookahead_distance)
	var target = player_pos + player_to_mouse
	var cam_pos = lerp(global_position, target, smoothing_speed * delta)
	global_position = cam_pos.floor()
