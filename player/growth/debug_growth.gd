extends Node

@onready var menchie: Node2D = %Menchie

func _physics_process(_delta: float) -> void:	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir.y == 0:
		return
		
	for child in menchie.get_children():
		if is_instance_of(child, GrowthManager):
			child.grow(-sign(input_dir.y))
