class_name DinoNeck extends AttachableLine2D

#region Exports
@export var curr_length: float = 96.0

## Number of bones in the neck
@export_range(3, 50, 1) var num_bones: int = 24:
	set(value):
		num_bones = value
		_init_bones()

## Each bone can rotate a maximum of ± this many degrees
@export_range(0.0, 360.0, 1.0, "degrees") var bone_max_rotation: float = 10.0:
	set(value):
		bone_max_rotation = value
		_bone_max_rotation = deg_to_rad(bone_max_rotation)

## What bone index the head attaches to
@export var head_bone_index: int = -1
		
@export_group("IK Configuration")
## More _bones = smoother curves but higher computation cost. Start low, increase if jerky.
## The setter rebuilds the bone arrays so you can see changes immediately in the editor.
@export_range(1, 32, 1) var ik_iterations: int = 32
## Higher iterations = more rigid _bones. Too low and the arm will stretch/compress.
@export_range(1, 20, 1) var constraint_iterations: int = 10
## Enable or disable constraints
@export var enable_constraint: bool = true
## Show rotation constraint gizmos during runtime?
@export var show_rotation_constraints: bool = false
## Per-bone movement lerp
@export var lerp_amount: float = 0.05
## Per-bone easing (to make bones further from the base have a higher lerp amount)
@export var ease_amount: float = 1.2
#endregion

#region Private variables
var _bones: Array[Vector2] = []
var _bone_lengths: Array[float] = []
var _base_position: Vector2
var _bone_max_rotation: float
#endregion

func _ready() -> void:
	_base_position = global_position
	_init_bones()
	super.attach(%Head, head_bone_index, true, AttachableLine2D.RotationUpdate.BACKWARD)
	_connect_parent()

func _physics_process(_delta: float) -> void:
	_base_position = global_position
	var target_position = get_global_mouse_position()
	var prev_bones = _bones.duplicate()
	_solve_ik(target_position)
	
	for i in range(num_bones + 1):
		# Make lerp amount ease so that the base is always attached to the body,
		# but the tip moves smoothly
		var ease_x = float(num_bones - i) / num_bones
		var curr_bone_lerp = ease(ease_x, ease_amount) + lerp_amount
		_bones[i] = prev_bones[i].lerp(_bones[i], curr_bone_lerp)
		
	_apply_length_constraints()
	_update_line2d()
	super(_delta)
	if show_rotation_constraints:
		queue_redraw()

func grow(progress: float) -> void:
	curr_length = Constants.growth_config.neck_length.sample(progress)
	width = Constants.growth_config.neck_width.sample(progress)
	var new_bone_length = curr_length / num_bones
	for i in range(len(_bone_lengths)):
		_bone_lengths[i] = new_bone_length
	super.update_attachments()

func _solve_ik(target_position: Vector2) -> void:
	var dist := _base_position.distance_squared_to(target_position)
	
	if dist > curr_length ** 2:
		_backward_pass()
		_forward_pass()
		return
		
	var min_dist := INF
	var min_bones: Array[Vector2]
	for _iter in range(ik_iterations):
		_backward_pass()
		_forward_pass()
		dist = _bones[-1].distance_squared_to(target_position)
		if dist < min_dist:
			min_dist = dist
			min_bones = _bones.duplicate()
		else:
			break
	
	if min_dist < dist:
		_bones = min_bones

# Backward: Start from the known good tip position and work back
# After this pass, tip is correct but base has drifted
func _backward_pass() -> void:
	_bones[num_bones] = get_global_mouse_position()
	# Seed with the direction of the last bone segment
	var root_angle := _bones[num_bones].angle_to_point(_bones[num_bones - 1])
	
	for i in range(num_bones - 1, -1, -1):
		var a := _bones[i + 1]  # child (already placed)
		var b := _bones[i]      # current bone to place
		
		# Compute how much b->a deviates from the running backward direction
		var diff_angle_raw := wrapf(a.angle_to_point(b) - root_angle, -PI, PI)
		var diff_angle := clampf(diff_angle_raw, -_bone_max_rotation, _bone_max_rotation)
		var angle := root_angle + diff_angle
		_bones[i] = a + Vector2(_bone_lengths[i], 0).rotated(angle)
		
		# Update root_angle for next (more base-ward) bone
		root_angle = a.angle_to_point(_bones[i])

# Forward: Re-anchor the base and propagate correct lengths forward
# After this pass, base is correct but tip has moved slightly off target
func _forward_pass() -> void:
	_bones[0] = _base_position
	var root_angle = global_rotation
	for i in range(num_bones):
		var a = _bones[i]
		var b = _bones[i + 1]
		var diff_angle_raw = wrapf(a.angle_to_point(b) - root_angle, -PI, PI)
		var diff_angle = clampf(diff_angle_raw, -_bone_max_rotation, _bone_max_rotation)
		var angle = root_angle + diff_angle
		_bones[i + 1] = a + Vector2(_bone_lengths[i], 0).rotated(angle)
		root_angle = angle
			
## Moves both _bones toward each other to fix bone stretching.
## Multiple iterations let corrections ripple through the chain.
func _apply_length_constraints() -> void:
	if not enable_constraint:
		return
	_bones[0] = _base_position

	for _iter in range(constraint_iterations):
		for i in range(num_bones):
			var current_vec: Vector2 = _bones[i + 1] - _bones[i]
			var distance: float = current_vec.length()

			# Bones can overlap during extreme IK solving (rapid target movements).
			# If that happens _bones can stay stuck.
			# If the distance is small, separate them with an arbitrary direction.
			if distance < 0.0001:
				_bones[i + 1] = _bones[i] + Vector2.RIGHT * _bone_lengths[i]
				continue

			# Calculate the error between current and target length
			var target_vec: Vector2 = current_vec.normalized() * _bone_lengths[i]
			var error_vec: Vector2 = target_vec - current_vec

			# Apply 25% of error to each bone (bilateral correction = 50% total)
			# Base is immovable anchor point - only its neighbor moves toward it
			if i > 0:
				_bones[i] -= error_vec * 0.25
			_bones[i + 1] += error_vec * 0.25

		_bones[0] = _base_position

func _update_line2d() -> void:
	clear_points()
	for pos in _bones:
		add_point(to_local(pos))

## Rebuilds bone arrays when num_bones or _curr_length changes.
## Starts with straight line upwards so IK has valid initial positions.
func _init_bones() -> void:
	_bone_max_rotation = deg_to_rad(bone_max_rotation)
	# Clear and rebuild arrays
	_bones.clear()
	_bone_lengths.clear()

	_bones.append(_base_position)
	var bone_length: float = curr_length / num_bones
	for i in range(num_bones):
		_bone_lengths.append(bone_length)
		_bones.append(_base_position + Vector2(bone_length * (i + 1), 0.0))

	_update_line2d()

func _connect_parent() -> void:
	if owner.has_signal("grew"):
		owner.connect("grew", Callable(self, "grow"))

func _draw() -> void:
	if not show_rotation_constraints:
		return
		
	for i in range(num_bones):
		if i > 0:
			var curr = _bones[i - 1]
			var from_prev = (_bones[i - 1] - _bones[i - 2]) if i > 2 else Vector2.RIGHT
			var min_angle_marker = from_prev.rotated(-_bone_max_rotation).normalized() * 20
			var max_angle_marker = from_prev.rotated(_bone_max_rotation).normalized() * 20
			draw_line(curr, curr + min_angle_marker, Color.AQUA, 0.5)
			draw_line(curr, curr + max_angle_marker, Color.AQUA, 0.5)
