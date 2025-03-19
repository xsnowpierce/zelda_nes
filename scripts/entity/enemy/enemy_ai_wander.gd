extends EnemyAI

class_name EnemyAI_Wander

@export var rotate_chance : float = 0.5
@export var move_speed : float = 23
var current_forward_vector : Vector2
var is_moving : bool = false
var raycast_offset : Vector2 = Vector2(8, 8)
@export var rotate_sprite : bool = true
@export var turn_towards_link_chance : float = 0.5

func _ready() -> void:
	super()
	rotate_enemy(get_rotate_direction())

func _physics_process(delta: float) -> void:
	if(GameSettings.camera_is_moving):
		return
	if(should_move()):
		try_rotate()
		move()

func try_rotate() -> void:
	if(randf_range(0, 1) > rotate_chance):
		rotate_enemy(get_rotate_direction())
	pass

func should_move() -> bool:
	return !is_moving

func move() -> void:
	if(is_moving or !can_move()):
		return
	is_moving = true
	var valid : bool = check_if_move_is_valid(current_forward_vector)
	if(valid):
		move_to_direction(current_forward_vector)
	else:
		var direction_array := [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		direction_array.shuffle()
		for direction in direction_array:
			if(check_if_move_is_valid(direction)):
				move_to_direction(direction)
				return
		print("couldnt find possible move") # no possible moves?

func check_if_move_is_valid(target_direction : Vector2) -> bool:
	if(Utils.is_out_of_bounds(get_target_position_from_direction(target_direction), camera, 1)):
		return false
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = $CollisionShape2D.shape
	query.transform = Transform2D(0, global_position + raycast_offset + (target_direction * 16))
	query.collision_mask = collision_layers_bitmask

	var result = space_state.intersect_shape(query)
	
	return result.size() == 0

func get_target_position_from_direction(target_direction : Vector2) -> Vector2:
	var target_position = (target_direction * 16) + global_position
	target_position = Utils.align_to_grid(target_position)
	return target_position

func move_to_direction(target_direction : Vector2) -> void:
	rotate_enemy(target_direction)
	var target_position = get_target_position_from_direction(target_direction)
	
		# move to position
	while (global_position.distance_to(target_position) > 1):
		if(is_attacked_knockback):
			target_position = global_position
			break
		if(!can_move()):
			await get_tree().process_frame
			continue
		var move_distance = move_speed * get_process_delta_time()
		global_position = global_position.move_toward(target_position, move_distance)
		await get_tree().process_frame
		
	global_position = target_position
	await moved_a_tile()
	is_moving = false

func moved_a_tile() -> void:
	pass

func rotate_enemy(direction : Vector2):
	current_forward_vector = direction
	if(rotate_sprite):
		match direction:
			Vector2.UP:
				$AnimatedSprite2D.play("up")
			Vector2.DOWN:
				$AnimatedSprite2D.play("down")
			Vector2.LEFT:
				$AnimatedSprite2D.play("left")
			Vector2.RIGHT:
				$AnimatedSprite2D.play("right")

func get_rotate_direction() -> Vector2:
	var link_in_view = is_link_in_view()
	if(link_in_view != Vector2.ZERO and randf_range(0, 1) >= turn_towards_link_chance):
		return link_in_view
	var random_number = randf_range(0, 1)
	if random_number >= 0.75:
		return Vector2.RIGHT
	if random_number < 0.75 and random_number >= 0.5:
		return Vector2.LEFT
	if random_number < 0.5 and random_number >= 0.25:
		return Vector2.DOWN
	else:
		return Vector2.UP

func is_link_in_view() -> Vector2:
	var our_relative_position = get_camera_relative_tile_position()
	var link_relative_position = link.get_player_camera_relative_tile_position()
	
	if our_relative_position.x == link_relative_position.x:
		if(link_relative_position.y > our_relative_position.y):
			return Vector2.DOWN
		else:
			Vector2.UP
	elif our_relative_position.y == link_relative_position.y:
		if(link_relative_position.x > our_relative_position.x):
			return Vector2.RIGHT
		else:
			return Vector2.LEFT
	return Vector2.ZERO

func get_camera_relative_tile_position() -> Vector2:
	var collider_centre = global_position + (Vector2(8, 8))
	collider_centre -= camera.global_position
	collider_centre.x /= 16
	collider_centre.y /= 11
	return Vector2(floori(collider_centre.x), floori(collider_centre.y))
