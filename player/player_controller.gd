class_name PlayerController extends Node

@onready var body: Node2D = %Menchie

func _physics_process(delta: float) -> void:	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	body.emit_signal("move", delta, input_dir)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			body.emit_signal("bite")
