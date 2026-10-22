## Configuration for growth of various body parts as the player levels up.
## All curve domains represent starting level to max level normalised to 0.0-1.0.
class_name GrowthConfig extends Resource

@export var camera_zoom: Curve

@export_group("Body")
@export var body_length: Curve
@export var body_width: Curve

@export_group("Neck")
@export var neck_length: Curve
@export var neck_width: Curve
@export var neck_bone_max_rotation: Curve
@export var head_scale: Curve

@export_group("Tail")
@export var tail_length: Curve
@export var tail_width: Curve

@export_group("Legs")
## Initial offset from the center of the pelvis to the front leg joints
@export var init_front_leg_joints_distance: float = 9.0
## Initial offset from the center of the chest to the hind leg joints
@export var init_hind_leg_joints_distance: float = 11.0
@export var leg_scale: Curve
@export var leg_step_length: Curve
@export var leg_move_speed: Curve
