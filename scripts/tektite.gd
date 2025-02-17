extends "res://scripts/enemy_ai.gd"

@export var jump_move_speed : float = 5
@export var jump_chance : float = 0.75
@export var jump_move_time : float = 1
@export var jump_height : float = 5
@export var max_jump_distance : Vector2 = Vector2(-16, 16)
@export var jump_timer : float = 1

var current_jump_timer : float
var is_jumping : bool

func _process(delta: float) -> void:
	super(delta)
	
	if(is_jumping):
		$AnimatedSprite2D.pause()
		$AnimatedSprite2D.frame = 1
		return
	else:
		if(!$AnimatedSprite2D.is_playing()):
			$AnimatedSprite2D.play()
		current_jump_timer -= delta
		if(current_jump_timer <= 0):
			jump()
			current_jump_timer = jump_timer

func jump() -> void:
	if(GameSettings.camera_is_moving):
		return
	if(randf_range(0, jump_chance) <= jump_chance):
		is_jumping = true
		jump_to_position(choose_random_jump_position(max_jump_distance))

func choose_random_jump_position(max_distance : Vector2) -> Vector2:
	
	var target_position : Vector2 = Vector2(randf_range(-max_distance.x, max_distance.x), 
	randf_range(-max_distance.y, max_distance.y))
	
	if target_position.x < 0: 
		target_position.x -= 16
	else:
		target_position.x += 16
		
	if target_position.y < 0: 
		target_position.y -= 16
	else:
		target_position.y += 16
	
	target_position += position
	
	target_position.x = snappedi(target_position.x, 8)
	target_position.y = snappedi(target_position.y, 8)
	
	target_position.x = clampi(target_position.x, camera.position.x + GameSettings.screen_boundaries.x, camera.position.x + GameSettings.screen_boundaries.y)
	target_position.y = clampi(target_position.y, camera.position.y + GameSettings.screen_boundaries.z, camera.position.y + GameSettings.screen_boundaries.w)
	
	return target_position

func mid_jump_height(start_position: Vector2, end_position: Vector2) -> float:
	var y_diff = end_position.y - start_position.y
	var mid_height : float = jump_height
	
	if y_diff > 0.0:
		# End is higher than start, bias towards jumping higher
		mid_height += y_diff * 0.5
	else:
		# End is lower than start, bias towards jumping lower
		mid_height += y_diff * 0.25
	
	mid_height = max(mid_height, jump_height)  # Enforce a minimum arc height
	
	return mid_height
	
func jump_to_position(end_position : Vector2) -> void:
	var starting_position = position
	var mid_height : float = mid_jump_height(starting_position, end_position)
	var highest_point = min(starting_position.y, end_position.y) - mid_height
	var b = 4 * (highest_point - starting_position.y) - (end_position.y - starting_position.y)
	var a = (end_position.y - starting_position.y) - b
	var current_jump_time : float = 0
	
	while current_jump_time < 1.0:
		if(GameSettings.camera_is_moving or !can_process()):
			await get_tree().process_frame
			continue
		current_jump_time += get_process_delta_time() * jump_move_speed  # Adjust speed to control the jump duration
		current_jump_time = min(current_jump_time, 1.0)
		var x = lerp(starting_position.x, end_position.x, current_jump_time)
		var y = a * current_jump_time * current_jump_time + b * current_jump_time + starting_position.y
		position = Vector2(x, y)
		await get_tree().process_frame
		
	position = end_position
	is_jumping = false
