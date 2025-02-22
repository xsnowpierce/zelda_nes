extends Node

class_name Utils

static var map_boundaries : Vector4 = Vector4()

static func is_out_of_bounds(global_position : Vector2, camera : Camera2D, outer_ring_is_invalid : bool = false) -> bool:
	return is_out_of_bounds_x(global_position, camera, outer_ring_is_invalid) and is_out_of_bounds_y(global_position, camera, outer_ring_is_invalid)
	
static func is_out_of_bounds_x(global_position : Vector2, camera : Camera2D, outer_ring_is_invalid : bool = false) -> bool:
	var relative_position : Vector2 = global_position - camera.position
	var x_boundary_left = GameSettings.screen_boundaries.x
	var x_boundary_right = GameSettings.screen_boundaries.y
	
	if(outer_ring_is_invalid):
		x_boundary_left += 16
		x_boundary_right -= 16
	
	if(relative_position.x < x_boundary_left):
		return true
	if(relative_position.x > x_boundary_right):
		return true
	return false

static func is_out_of_bounds_y(global_position : Vector2, camera : Camera2D, outer_ring_is_invalid : bool = false) -> bool:
	var relative_position : Vector2 = global_position - camera.position
	var y_boundary_top = GameSettings.screen_boundaries.z
	var y_boundary_bottom = GameSettings.screen_boundaries.w
	if(outer_ring_is_invalid):
		y_boundary_top += 16
		y_boundary_bottom -= 16
	
	if(relative_position.y < y_boundary_top):
		return true
	if(relative_position.y > y_boundary_bottom):
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
