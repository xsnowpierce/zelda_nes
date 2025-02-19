extends Node

@export var move_speed : float = 65
var movement : Vector2
var last_velocity : Vector2
#screen transition variables
var max_x_until_new_screen : float = 120
var max_y_until_new_screen : float = 87
signal call_new_screen(direction : Vector2)
signal sprite_update(movement : Vector2, velocity : Vector2)
var current_colliding_enemies : int = 0

var player : CharacterBody2D

func initialize(parent: CharacterBody2D) -> void:
	player = parent
	self.connect("call_new_screen", Callable(player.camera, "_on_link_call_new_screen"))
	
func process(delta: float) -> void:
	var new_screen_check : Vector2 = check_for_new_screen()
	if(new_screen_check == Vector2.ZERO):
		if (player.get_player_state().is_attacked_knockback):
			keep_player_in_screen()
		
		if(player.get_player_state().is_player_input_allowed()):
			calculate_movement(false)
			player.move_and_slide()
		
		sprite_update.emit(movement, player.velocity)
	else:
		call_new_screen.emit(new_screen_check)
		sprite_update.emit(movement, player.velocity)
		
	
	if(!player.get_player_state().is_player_input_allowed()):
		keep_player_in_screen()

func keep_player_in_screen() -> void:
	var camera_position = get_tree().get_first_node_in_group("Camera").position
	var relative_position = player.position - camera_position
	if(relative_position.x < GameSettings.screen_boundaries.x):
		player.position.x = camera_position.x + GameSettings.screen_boundaries.x
	if(relative_position.x > GameSettings.screen_boundaries.y):
		player.position.x = camera_position.x + GameSettings.screen_boundaries.y
	if(relative_position.y < GameSettings.screen_boundaries.z):
		player.position.y = camera_position.y + GameSettings.screen_boundaries.z
	if(relative_position.y > GameSettings.screen_boundaries.w):
		player.position.y = camera_position.y + GameSettings.screen_boundaries.w
		
func calculate_movement(ignore_inputs : bool) -> void:
	if(player.get_player_state().is_position_correcting):
		return
		
	movement = Vector2.ZERO
	if(!ignore_inputs):
		if(Input.is_action_pressed("move_left")):
			movement.x -= 1
		if(Input.is_action_pressed("move_right")):
			movement.x += 1
		if(Input.is_action_pressed("move_down")):
			movement.y += 1
		if(Input.is_action_pressed("move_up")):
			movement.y -= 1
	
	if(movement.x != 0.0 and movement.y != 0.0):
		movement.x = 0.0
		
	# correct position to grid here
	var snapped_position : Vector2 = player.position

	if movement.x != 0:
		snapped_position.y = snapped(player.position.y, 8)
	elif movement.y != 0:
		snapped_position.x = snapped(player.position.x, 8)

	# Check if the snapped position is different from the current position
	if player.position.distance_to(snapped_position) > 2:
		var velocity := Vector2(-sign(player.position.x - snapped_position.x), -sign(player.position.y - snapped_position.y))
		sprite_update.emit(movement, velocity)
		player.position = player.position.lerp(snapped_position, get_process_delta_time() * move_speed)
	else:
		player.position = snapped_position
		
		if(movement != Vector2.ZERO and can_move()):
			player.velocity = movement * move_speed
		
		else:
			player.velocity = Vector2.ZERO
	
func correct_position_to_grid(value : float, alignTo : int) -> float:
	var difference = fmod(value, alignTo)
	var halfwayPoint = (alignTo - 1) / 2.0
	if(difference > halfwayPoint):
		return alignTo - difference
	return -difference
	
func can_move() -> bool:
	if(player.get_player_state().is_attacking):
		return false
	return true

func check_for_new_screen() -> Vector2:
	var relative_position = player.position - get_tree().get_first_node_in_group("Camera").position
	
	if(relative_position.x < GameSettings.screen_boundaries.x and Input.is_action_pressed("move_left")):
		return Vector2(-1, 0)
	elif(relative_position.x > GameSettings.screen_boundaries.y and Input.is_action_pressed("move_right")):
		return Vector2(1, 0)
	elif(relative_position.y < GameSettings.screen_boundaries.z and Input.is_action_pressed("move_up")):
		return Vector2(0, -1)
	elif(relative_position.y > GameSettings.screen_boundaries.w and Input.is_action_pressed("move_down")):
		return Vector2(0, 1)
		
	return Vector2.ZERO
