class_name DinoMain extends Node2D

@onready var body: DinoBody = %Body
@onready var head: DinoHead = %Head

## Grow bigger, progress is level/max_level normalised to 0.0-1.0
signal grew(progress: float)

func _ready() -> void:
	Global.player = self
	EventBus.level_up.connect(_on_level_up)

func move(delta: float, dir: Vector2) -> void:
	body.move(delta, dir)

func bite() -> void:
	head.try_bite()
	
func _on_level_up(new_level: int) -> void:
	var progress = float(new_level) / Constants.max_level
	grew.emit(progress)
