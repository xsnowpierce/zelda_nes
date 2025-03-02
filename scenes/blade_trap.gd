extends EnemyAI

var raycast_offset : Vector2 = Vector2(8, 8)
## The layer to check for the player to move to.
@export_flags_2d_physics var raycast_layer
@export var move_towards_speed : float
@export var move_backwards_speed : float
@export var blade_trap_settings : BladeTrapSettings

var is_moving : bool

func load_blade_trap_settings(settings : BladeTrapSettings) -> void:
	blade_trap_settings = settings

func physics_update() -> void:
	if(!is_moving):
		if(blade_trap_settings.max_tiles_up != 0):
			check_for_link(Vector2.UP)
		if(blade_trap_settings.max_tiles_down != 0):
			check_for_link(Vector2.DOWN)
		if(blade_trap_settings.max_tiles_left != 0):
			check_for_link(Vector2.LEFT)
		if(blade_trap_settings.max_tiles_right != 0):
			check_for_link(Vector2.RIGHT)

func check_for_link(direction : Vector2) -> void:
	var space_state = get_world_2d().direct_space_state
	var start_position : Vector2 = global_position + raycast_offset
	var query = PhysicsRayQueryParameters2D.create(start_position, start_position + 
		(direction * (get_max_tiles_from_direction(direction) * 16)), raycast_layer, [self])
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if(!result.is_empty()):
		move(direction)

func move(direction : Vector2) -> void:
	is_moving = true
	var starting_position = global_position
	var target_position = starting_position + ((direction * 16) * get_max_tiles_from_direction(direction))
	await move_to_position(target_position, move_towards_speed)
	await move_to_position(starting_position, move_backwards_speed)
	is_moving = false

func move_to_position(target_position : Vector2, move_speed : float)-> void:
	# move to position
	while (global_position.distance_to(target_position) > 1):
		if(!can_move()):
			await get_tree().process_frame
			continue
		var move_distance = move_speed * get_process_delta_time()
		global_position = global_position.move_toward(target_position, move_distance)
		await get_tree().process_frame
		
	global_position = target_position

func can_move() -> bool:
	if GameSettings.camera_is_moving or !can_process():
		return false
	return true

func get_max_tiles_from_direction(direction : Vector2) -> int:
	match direction:
		Vector2.UP:
			return blade_trap_settings.max_tiles_up
		Vector2.DOWN:
			return blade_trap_settings.max_tiles_down
		Vector2.LEFT:
			return blade_trap_settings.max_tiles_left
		Vector2.RIGHT:
			return blade_trap_settings.max_tiles_right
		_:
			return 0

func attacked() -> void:
	return
func death() -> void:
	return
