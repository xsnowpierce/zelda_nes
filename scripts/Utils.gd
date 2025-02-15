extends Node

static var map_boundaries : Vector4 = Vector4()

static func is_out_of_bounds(global_position : Vector2, camera : Camera2D) -> bool:
	var relative_position = global_position - camera.position
	if(relative_position.x < GameSettings.screen_boundaries.x):
		return true
	if(relative_position.x > GameSettings.screen_boundaries.y):
		return true
	if(relative_position.y < GameSettings.screen_boundaries.z):
		return true
	if(relative_position.y > GameSettings.screen_boundaries.w):
		return true
	return false

static func align_to_grid(value : Vector2, align : int = 16) -> Vector2:
	value.x = snapped(value.x, align)
	value.y = snappedi(value.y, align)
	return value
