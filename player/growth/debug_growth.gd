extends Node

@onready var menchie: DinoMain = %Menchie
@export_range(1, Constants.max_level) var _curr_level: int = 1
		
func _ready() -> void:
	menchie.grow_to(_curr_level)

func _physics_process(_delta: float) -> void:	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir.y == 0:
		return
	
	_curr_level += -sign(input_dir.y)
	_curr_level = clampi(_curr_level, 1, Constants.max_level)
	menchie.grow_to(_curr_level)
	%LevelLabel.text = "Current Level: " + str(_curr_level)
