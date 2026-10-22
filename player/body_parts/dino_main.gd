class_name DinoMain extends Node2D

@onready var body: DinoBody = %Body
@onready var neck: DinoNeck = %Neck
@onready var head: DinoHead = %Head
@onready var legs: DinoLegs = %Legs
@onready var tail: DinoTail = %Tail

func _ready() -> void:
	Global.player = self
	EventBus.level_up.connect(_on_level_up)

func move(delta: float, dir: Vector2) -> void:
	body.move(delta, dir)

func bite() -> void:
	head.try_bite()
	
## Grow the dinosaur, call order is important
func grow(level: int) -> void:
	var progress = float(level) / Constants.max_level
	body.grow(progress)
	neck.grow(progress)
	head.grow(progress)
	legs.grow(progress)
	tail.grow(progress)
	
func _on_level_up(new_level: int) -> void:
	grow(new_level)
