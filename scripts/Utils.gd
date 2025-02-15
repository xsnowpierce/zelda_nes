extends Node

class_name Utils

static var map_boundaries : Vector4 = Vector4()

static func is_out_of_bounds(global_position : Vector2, camera : Camera2D) -> bool:
	var relative_position : Vector2 = global_position - camera.position
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
	value.x = roundi(value.x)
	value.y = roundi(value.y)
	value.x = snapped(value.x, align)
	value.y = snappedi(value.y, align)
	return value

static func check_position_for_colliders(target_position : Vector2, collision_layermask : int, world2d : World2D) -> bool:
	# cast ray to see if we can go here
	var space : PhysicsDirectSpaceState2D = world2d.direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = target_position + Vector2(8,8) # add 8 to get centre of point
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = true
	parameters.collision_mask = collision_layermask
	var result : Array[Dictionary] = space.intersect_point(parameters)
	if(!result.is_empty()):
		return true
	return false
