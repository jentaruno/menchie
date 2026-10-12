class_name DinoMain extends Node2D

@onready var body: DinoBody = %Body
@onready var head: DinoHead = %Head

## Grow bigger, progress is level/max_level normalised to 0.0-1.0
signal grew(progress: float)

func _ready() -> void:
	Global.player = self

func move(delta: float, dir: Vector2) -> void:
	body.move(delta, dir)

func bite() -> void:
	head.try_bite()
	
func grow_to(level: int) -> void:
	var progress = float(level) / Constants.max_level
	grew.emit(progress)
