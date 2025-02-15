extends ColorRect

@export var position_offset : Vector2 = Vector2(30, 29)
@export var map_boundaries : Vector4 = Vector4(-7, -7, 7, 0)
var camera : Camera2D

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	camera.connect("camera_moved", Callable(self, "camera_has_moved"))

func camera_has_moved(new_coord : Vector2) -> void:
	if(is_position_outside_boundary(new_coord, map_boundaries)):
		return
	var adjusted_grid_position = new_coord * 4 + position_offset
	$position.position = adjusted_grid_position

func is_position_outside_boundary(pos : Vector2, boundary : Vector4) -> bool:
	if(pos.x < boundary.x):
		return true
	elif pos.x > boundary.z:
		return true
	elif pos.y < boundary.y:
		return true
	elif pos.y > boundary.w:
		return true
	return false
