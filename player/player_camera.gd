class_name PlayerCamera extends Camera2D

## Camera lerp speed
@export var smoothing_speed: float = 2.0
## Maximum distance to look ahead of the player body
@export var initial_max_lookahead_distance: float = 100.0
var _max_lookahead_distance: float = initial_max_lookahead_distance

func _ready() -> void:
	Global.player_camera = self
	EventBus.level_up.connect(_on_level_up)

func _physics_process(delta: float) -> void:
	var player_pos = Global.player.global_position
	var mouse_pos = get_global_mouse_position()
	var player_to_mouse = (mouse_pos - player_pos).limit_length(_max_lookahead_distance)
	var target = player_pos + player_to_mouse
	var cam_pos = lerp(global_position, target, smoothing_speed * delta)
	global_position = cam_pos.floor()

func _on_level_up(level: int) -> void:
	var progress = float(level) / Constants.max_level
	var zoom_scale = Constants.growth_config.camera_zoom.sample(progress)
	zoom = Vector2.ONE * zoom_scale
	_max_lookahead_distance = initial_max_lookahead_distance / zoom_scale
