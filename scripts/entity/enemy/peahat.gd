extends EnemyAI

@export var move_speed : float = 30
@export var random_stop_timer : Vector2 = Vector2(5, 12)
@export var stay_stopped_time : Vector2 = Vector2(2.4, 4)
@export var slowdown_speed : float = .5
@export var random_tiles_until_direction_change : Vector2 = Vector2(1, 3)
var current_slowdown_value = 0
var current_direction : Vector2
var is_moving : bool
enum PEAHAT_STATE {SPINNING, TRANSITION, STOPPED}
var current_state : PEAHAT_STATE
var time_until_stop : float
var random_direction_change : int
@export var can_be_hit_in_flight = false

func _ready() -> void:
	await get_tree().process_frame
	super()
	current_direction = get_random_direction()
	current_state = PEAHAT_STATE.TRANSITION
	current_slowdown_value = 0
	
	random_direction_change = randi_range(random_tiles_until_direction_change.x, random_tiles_until_direction_change.y)
	move()
	speed_control()

func _process(delta: float) -> void:
	super(delta)
	$AnimatedSprite2D.speed_scale = current_slowdown_value

func speed_control() -> void:
	current_state = PEAHAT_STATE.TRANSITION
	while current_slowdown_value < 1:
		current_slowdown_value += get_process_delta_time() * slowdown_speed
		await get_tree().process_frame
	
	current_state = PEAHAT_STATE.SPINNING
	current_slowdown_value = 1
	time_until_stop = randf_range(random_stop_timer.x, random_stop_timer.y)

	while true:
		time_until_stop -= get_process_delta_time()
		if time_until_stop <= 0:
			current_state = PEAHAT_STATE.TRANSITION
			while current_slowdown_value > 0:
				current_slowdown_value -= get_process_delta_time() * slowdown_speed
				await get_tree().process_frame
			current_slowdown_value = 0

			current_state = PEAHAT_STATE.STOPPED
			await get_tree().create_timer(randf_range(stay_stopped_time.x, stay_stopped_time.y)).timeout

			current_state = PEAHAT_STATE.TRANSITION
			while current_slowdown_value < 1:
				current_slowdown_value += get_process_delta_time() * slowdown_speed
				await get_tree().process_frame
			
			current_state = PEAHAT_STATE.SPINNING
			current_slowdown_value = 1
			time_until_stop = randf_range(random_stop_timer.x, random_stop_timer.y)
		
		await get_tree().process_frame


func move() -> void:
	while true:
		await move_to_direction(current_direction)
		random_direction_change -= 1
		if(random_direction_change <= 0):
			current_direction = get_random_adjacent_angle(current_direction)
			random_direction_change = randi_range(random_tiles_until_direction_change.x, random_tiles_until_direction_change.y)

func get_target_position_from_direction(target_direction : Vector2) -> Vector2:
	var target_position = (target_direction * 8) + global_position
	target_position = Utils.align_to_grid(target_position, 8)
	if(Utils.is_out_of_bounds(target_position, camera, true)):
		target_position = (-target_direction * 8) + global_position
		current_direction = -current_direction
		target_position = Utils.align_to_grid(target_position, 8)
	
	return target_position

func move_to_direction(target_direction : Vector2) -> void:
	if(is_moving):
		return
	is_moving = true
	var target_position = get_target_position_from_direction(target_direction)
	
		# move to position
	while (global_position.distance_to(target_position) > 1):
		var move_distance = move_speed * current_slowdown_value * get_process_delta_time()  # Distance to move this frame
		global_position = global_position.move_toward(target_position, move_distance)  # Move at constant speed
		await get_tree().process_frame
		
	global_position = target_position
	is_moving = false

func get_random_adjacent_angle(base_vector : Vector2) -> Vector2:
	var adjacent_angles : Array = get_adjacent_angles(base_vector)
	return adjacent_angles[randi() % adjacent_angles.size()]

func get_adjacent_angles(base_vector: Vector2) -> Array:
	var directions = [
		Vector2.RIGHT, 
		Vector2.DOWN + Vector2.RIGHT, 
		Vector2.DOWN, 
		Vector2.DOWN + Vector2.LEFT, 
		Vector2.LEFT, 
		Vector2.UP + Vector2.LEFT, 
		Vector2.UP, 
		Vector2.UP + Vector2.RIGHT
	]
	
	base_vector = base_vector.normalized()

	var closest_index = -1
	var min_distance = INF

	for i in range(directions.size()):
		var dist = base_vector.distance_squared_to(directions[i])
		if dist < min_distance:
			min_distance = dist
			closest_index = i

	var adjacent_dirs = []
	adjacent_dirs.append(directions[(closest_index - 1 + directions.size()) % directions.size()])
	adjacent_dirs.append(directions[(closest_index + 1) % directions.size()])

	return adjacent_dirs


func get_random_direction() -> Vector2:
	var directions = [
		Vector2.RIGHT, 
		Vector2.DOWN + Vector2.RIGHT, 
		Vector2.DOWN, 
		Vector2.DOWN + Vector2.LEFT, 
		Vector2.LEFT, 
		Vector2.UP + Vector2.LEFT, 
		Vector2.UP, 
		Vector2.UP + Vector2.RIGHT
	]
	var random : Vector2 = directions[randi() % directions.size()]
	return random

func attacked() -> void:
	if(!can_be_hit_in_flight and current_state != PEAHAT_STATE.STOPPED):
		return
	super()
