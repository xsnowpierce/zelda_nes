extends CharacterBody2D

var game_data : Node

@export_group("Movement")
@export var move_speed : float = 65
var movement : Vector2
var last_velocity : Vector2
var is_position_correcting : bool
signal move_velocity(velocity : Vector2)

#screen transition variables
var max_x_until_new_screen : float = 120
var max_y_until_new_screen : float = 87
signal call_new_screen(direction : Vector2)
var current_colliding_enemies : int = 0

@export_group("Combat")
var is_attacking : bool = false
@export var attacked_iframes : float = 16
var current_attacked_iframes : float
var is_attacked_knockback : bool
@export var attacked_knockback_force : float = 140
@export var attacked_knockback_duration : float = .2

@export_group("SFX Files")
@export var sword_swing_sound := preload("res://sound/sfx/sword_Swing.wav")
@export var attacked_sound := preload("res://sound/sfx/The Legend of Zelda Cartoon Sound Effects Player Hurt.wav")
@export var door_enter_sound := preload("res://sound/sfx/The Legend of Zelda Cartoon Sound Effects Walking on Stairs.wav")
@export var key_item_pickup := preload("res://sound/sfx/The Legend of Zelda Cartoon Sound Effects Item Received.wav")

#door entering variables
var colliding_with_door : Area2D
var is_entering_door : bool = false
var is_exiting_door : bool = false
var has_room_events : bool = false
signal entering_door(door : Area2D)
var is_inside_room : bool

var is_pickup_animation : bool
@export_group("Pickup Animation")
@export var pickup_animation_length : float

@export_group("Equipment")
@export var current_equipped_a : ENUM.KEY_ITEM_TYPE
@export var current_equipped_b : ENUM.KEY_ITEM_TYPE

func _ready() -> void:
	game_data = get_tree().get_first_node_in_group("GameData")
	var camera := get_tree().get_first_node_in_group("Camera")
	self.connect("call_new_screen", Callable(camera, "_on_link_call_new_screen"))
	pass

func _process(delta: float) -> void:
	if(colliding_with_door != null):
		check_door_collision()
	current_attacked_iframes -= delta
	var new_screen_check : Vector2 = check_for_new_screen()
	if(is_player_input_allowed()):
		if (new_screen_check == Vector2.ZERO):
			if(is_attacked_knockback):
				keep_player_in_screen()
				return
			calculate_movement(false)
			move_and_slide()
			$"Link Sprite Mask/Link Sprite".set_look_direction(movement)
			$"Link Sprite Mask/Link Sprite".set_current_velocity(velocity)
			$"Attack Area".set_direction(movement)
			check_attack()
		else:
			$"Link Sprite Mask/Link Sprite".set_look_direction(movement)
			$"Link Sprite Mask/Link Sprite".set_current_velocity(velocity)
			$"Attack Area".set_direction(movement)
			call_new_screen.emit(new_screen_check)
	else:
		keep_player_in_screen()
		
func is_player_input_allowed() -> bool:
	return (!GameSettings.camera_is_moving 
		and !is_entering_door 
		and !is_exiting_door 
		and !has_room_events 
		and !is_pickup_animation)

func get_look_direction() -> Vector2:
	return $"Link Sprite Mask/Link Sprite".current_direction

func keep_player_in_screen() -> void:
	var camera_position = get_tree().get_first_node_in_group("Camera").position
	var relative_position = position - camera_position
	if(relative_position.x < GameSettings.screen_boundaries.x):
		position.x = camera_position.x + GameSettings.screen_boundaries.x
	if(relative_position.x > GameSettings.screen_boundaries.y):
		position.x = camera_position.x + GameSettings.screen_boundaries.y
	if(relative_position.y < GameSettings.screen_boundaries.z):
		position.y = camera_position.y + GameSettings.screen_boundaries.z
	if(relative_position.y > GameSettings.screen_boundaries.w):
		position.y = camera_position.y + GameSettings.screen_boundaries.w
		
func calculate_movement(ignore_inputs : bool) -> void:
	if(is_position_correcting):
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
	var snapped_position : Vector2 = position

	if movement.x != 0:
		snapped_position.y = snapped(position.y, 8)
	elif movement.y != 0:
		snapped_position.x = snapped(position.x, 8)

	# Check if the snapped position is different from the current position
	if position.distance_to(snapped_position) > 2:
		move_velocity.emit(Vector2(-sign(position.x - snapped_position.x), -sign(position.y - snapped_position.y)))
		position = position.lerp(snapped_position, get_process_delta_time() * move_speed)
	else:
		position = snapped_position
		
		if(movement != Vector2.ZERO and can_move()):
			velocity = movement * move_speed
		
		else:
			velocity = Vector2.ZERO
	
func correct_position_to_grid(value : float, alignTo : int) -> float:
	var difference = fmod(value, alignTo)
	var halfwayPoint = (alignTo - 1) / 2.0
	if(difference > halfwayPoint):
		return alignTo - difference
	return -difference
	
func can_move() -> bool:
	if(is_attacking):
		return false
	return true

func check_for_new_screen() -> Vector2:
	var relative_position = position - get_tree().get_first_node_in_group("Camera").position
	
	if(relative_position.x < GameSettings.screen_boundaries.x and Input.is_action_pressed("move_left")):
		return Vector2(-1, 0)
	elif(relative_position.x > GameSettings.screen_boundaries.y and Input.is_action_pressed("move_right")):
		return Vector2(1, 0)
	elif(relative_position.y < GameSettings.screen_boundaries.z and Input.is_action_pressed("move_up")):
		return Vector2(0, -1)
	elif(relative_position.y > GameSettings.screen_boundaries.w and Input.is_action_pressed("move_down")):
		return Vector2(0, 1)
		
	return Vector2.ZERO
	

func check_attack() -> void:
	if(Input.is_action_just_pressed("attack") and !is_attacking):
		if(current_equipped_a == ENUM.KEY_ITEM_TYPE.NULL):
			return
		match current_equipped_a:
			ENUM.KEY_ITEM_TYPE.WOODEN_SWORD:
				is_attacking = true
				$"Link Sprite Mask/Link Sprite"._on_character_body_2d_attack()
				$"Attack Area"._on_link_attack()
				$AudioPlayer.stream = sword_swing_sound
				$AudioPlayer.play()
	if(Input.is_action_just_pressed("alternate_attack") and !is_attacking):
		if(current_equipped_b == ENUM.KEY_ITEM_TYPE.NULL):
			return
		match current_equipped_b:
			ENUM.KEY_ITEM_TYPE.WOODEN_SWORD:
				is_attacking = true
				$"Link Sprite Mask/Link Sprite"._on_character_body_2d_attack()
				$"Attack Area"._on_link_attack()
				$AudioPlayer.stream = sword_swing_sound
				$AudioPlayer.play()

func _on_animated_sprite_2d_attack_ended() -> void:
	is_attacking = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Enemy") or area.is_in_group("Enemy_Attack")):
		attacked(area.global_position)
	if(area.is_in_group("EntranceDoor") and (!is_entering_door and !is_exiting_door)):
		colliding_with_door = area

func _on_link_hitbox_area_exited(area: Area2D) -> void:
	if(area.is_in_group("EntranceDoor")):
		colliding_with_door = null
		

func check_door_collision() -> void:
	var grid_position = position - Vector2(8,8)
	var target_position = colliding_with_door.global_position
	grid_position.x = roundi(grid_position.x)
	grid_position.y = roundi(grid_position.y)
	if(colliding_with_door.is_wide_horizontal):
		grid_position.x = 0
		target_position.x = 0
	if(colliding_with_door.is_tall_vertical):
		grid_position.y = 0
		target_position.y = 0
	if(grid_position == target_position):
		if(is_inside_room):
			exit_door()
		else:
			enter_door()

func enter_door() -> void:
	if(is_entering_door or is_exiting_door):
		return
	is_entering_door = true
	position = (colliding_with_door.global_position + Vector2(8,8))
	entering_door.emit(colliding_with_door)
	game_data.player_start_enter_door(colliding_with_door)
	$AudioPlayer.stream = door_enter_sound
	$AudioPlayer.play(0.0)
	var start_sprite_y : float = $"Link Sprite Mask/Link Sprite".position.y
	await enter_door_sprite_animation()
	game_data.player_finish_enter_door(colliding_with_door)
	$"Link Sprite Mask".clip_contents = false
	$"Link Sprite Mask/Link Sprite".position.y = start_sprite_y
	is_inside_room = true
	is_entering_door = false
	
func wait_for_room_events() -> void:
	has_room_events = true
	
func finish_room_events() -> void:
	has_room_events = false
	
func exit_door() -> void:
	if(is_exiting_door or is_entering_door):
		return
	is_exiting_door = true
	get_parent().player_finish_enter_door(colliding_with_door)
	$AudioPlayer.stream = door_enter_sound
	$AudioPlayer.play(0.0)
	var start_sprite_y : float = $"Link Sprite Mask/Link Sprite".position.y
	
	await exit_door_sprite_animation()
	$"Link Sprite Mask".clip_contents = false
	$"Link Sprite Mask/Link Sprite".position.y = start_sprite_y
	is_inside_room = false
	is_exiting_door = false
	
func enter_door_sprite_animation() -> void:
	var target_position : float = 24
	var pixel_drop_speed : float = 15
	$"Link Sprite Mask/Link Sprite".play("up")
	$"Link Sprite Mask".clip_contents = true
	while $"Link Sprite Mask/Link Sprite".position.y < target_position:
		$"Link Sprite Mask/Link Sprite".position.y += get_process_delta_time() * pixel_drop_speed
		await get_tree().process_frame
	$"Link Sprite Mask/Link Sprite".pause()

func exit_door_sprite_animation() -> void:
	var target_position : float = 8
	var pixel_rise_speed : float = 15
	$"Link Sprite Mask/Link Sprite".position.y = 24
	$"Link Sprite Mask/Link Sprite".play("down")
	$"Link Sprite Mask".clip_contents = true
	while $"Link Sprite Mask/Link Sprite".position.y > target_position:
		$"Link Sprite Mask/Link Sprite".position.y -= get_process_delta_time() * pixel_rise_speed
		await get_tree().process_frame
	$"Link Sprite Mask/Link Sprite".pause()

func attacked(from : Vector2) -> void:
	if(current_attacked_iframes > 0):
		return
	
	current_attacked_iframes = (attacked_iframes / 60)
	is_attacked_knockback = true
	$AudioPlayer.stream = attacked_sound
	$AudioPlayer.play()
	get_parent().player_took_damage(1)
	var knockback_direction : Vector2 = (Vector2(global_position.x, global_position.y) - Vector2(from.x - 8, from.y - 8))
	if(abs(knockback_direction.x) > abs(knockback_direction.y)):
		knockback_direction.y = 0
		if(knockback_direction.x > 0):
			knockback_direction.x = 1
		else:
			knockback_direction.x = -1
	else: 
		knockback_direction.x = 0
		if(knockback_direction.y > 0):
			knockback_direction.y = 1
		else:
			knockback_direction.y = -1
	
	var knockbacktimer : float = 0
	while (knockbacktimer < attacked_knockback_duration):
		knockbacktimer += get_process_delta_time()
		velocity = knockback_direction * attacked_knockback_force
		move_and_slide()
		await get_tree().process_frame
	
	is_attacked_knockback = false

func picked_up_key_item(type : ENUM.KEY_ITEM_TYPE) -> void:
	game_data.player_pickup_key_item(type)
	$AudioPlayer.stream = key_item_pickup
	$AudioPlayer.play()
	is_pickup_animation = true
	var current_animation = $"Link Sprite Mask/Link Sprite".animation
	$"Link Sprite Mask/Link Sprite".play("item_pickup")
	await get_tree().create_timer(pickup_animation_length).timeout
	$"Link Sprite Mask/Link Sprite".animation = current_animation
	is_pickup_animation = false
