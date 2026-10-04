extends Sprite2D

func _physics_process(_delta: float) -> void:
	var pos = Global.player_camera.global_position
	texture.noise.offset = Vector3(pos.x, pos.y, 0.0)
