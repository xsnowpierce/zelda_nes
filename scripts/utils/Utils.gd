extends Node

class_name Utils

static var map_boundaries : Vector4 = Vector4()

static func is_out_of_bounds(global_position : Vector2, camera : Camera2D, outer_rings_invalid : int = 1) -> bool:
	return is_out_of_bounds_x(global_position, camera, outer_rings_invalid) or is_out_of_bounds_y(global_position, camera, outer_rings_invalid)
	
static func is_out_of_bounds_x(global_position : Vector2, camera : Camera2D, outer_rings_invalid : int = 1) -> bool:
	var relative_position : Vector2 = global_position - camera.global_position
	var x_boundary_left = GameSettings.screen_boundaries.x
	var x_boundary_right = GameSettings.screen_boundaries.y
	
	x_boundary_left += 16 * outer_rings_invalid
	x_boundary_right -= 16 * outer_rings_invalid
	
	if(relative_position.x < x_boundary_left):
		return true
	if(relative_position.x > x_boundary_right):
		return true
	return false

static func is_out_of_bounds_y(global_position : Vector2, camera : Camera2D, outer_rings_invalid : int = 1) -> bool:
	var relative_position : Vector2 = global_position - camera.global_position
	var y_boundary_top = GameSettings.screen_boundaries.z
	var y_boundary_bottom = GameSettings.screen_boundaries.w
	y_boundary_top += 16 * outer_rings_invalid
	y_boundary_bottom -= 32 * outer_rings_invalid
	
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

static func get_tile_coordinate_from_global_coordinate(global_position : Vector2) -> Vector2:
	return Vector2i(roundi(global_position.x / GameSettings.map_screen_size.x), roundi(global_position.y / GameSettings.map_screen_size.y))
	
static func get_global_coordinate_from_tile_coordinate(tile_coordinate : Vector2) -> Vector2:
	tile_coordinate.x *= 16 * 16
	tile_coordinate.y *= 11 * 16
	return tile_coordinate

static func degrees_to_vector(degrees : float) -> Vector2:
	var radians = deg_to_rad(degrees)
	return Vector2(sin(radians), -cos(radians)).normalized()

static func vec4_to_colour(vec : Vector4) -> Color:
	return Color(vec.x, vec.y, vec.z, vec.w)

static func colour_to_vec4(colour : Color) -> Vector4:
	return Vector4(colour.r, colour.g, colour.b, colour.a)
