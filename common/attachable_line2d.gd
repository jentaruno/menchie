@abstract class_name AttachableLine2D extends Line2D

enum RotationUpdate { NONE, FORWARD, BACKWARD }

class PointAttachment:
	var anchor_index: int
	var update_position: bool = true
	var update_rotation: RotationUpdate = RotationUpdate.FORWARD
	
	func _init(point: int, up_position: bool = true, up_rotation: RotationUpdate = RotationUpdate.FORWARD) -> void:
		anchor_index = point
		update_position = up_position
		update_rotation = up_rotation

var _attachments: Dictionary[Node, PointAttachment]

func attach(node: Node, anchor_index: int, update_position: bool = true, update_rotation: RotationUpdate = RotationUpdate.FORWARD) -> void:
	_attachments.get_or_add(node)
	_attachments[node] = PointAttachment.new(anchor_index, update_position, update_rotation)

func _physics_process(_delta: float) -> void:
	for node in _attachments:
		_update_transform(node, _attachments[node])
		
func _update_transform(node: Node2D, pa: PointAttachment) -> void:
	if pa.update_position:
		node.global_position = to_global(points[pa.anchor_index])
	if pa.update_rotation != RotationUpdate.NONE:
		var a = to_global(points[pa.anchor_index])
		var b = to_global(points[pa.anchor_index - 1])
		var dir: Vector2	
		if pa.update_rotation == RotationUpdate.FORWARD:
			dir = a.direction_to(b)
		elif pa.update_rotation == RotationUpdate.BACKWARD:
			dir = b.direction_to(a)
		node.global_rotation = dir.angle()
