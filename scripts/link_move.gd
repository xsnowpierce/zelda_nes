extends CharacterBody2D

@export var move_speed : float = 65
var movement : Vector2
var last_velocity : Vector2
var is_position_correcting : bool
signal move_velocity(velocity : Vector2)
var max_x_until_new_screen : float = 120
var max_y_until_new_screen : float = 87
signal call_new_screen(direction : Vector2)
var is_attacking : bool = false
var current_colliding_enemies : int = 0
@export var attacked_iframes : float = 16
var current_attacked_iframes : float
var is_attacked_knockback : bool
@export var attacked_knockback_force : float = 140
@export var attacked_knockback_duration : float = .2
@export var sword_swing_sound := preload("res://sound/sfx/sword_Swing.wav")
@export var attacked_sound := preload("res://sound/sfx/The Legend of Zelda Cartoon Sound Effects Player Hurt.wav")
# this goes by Vector4(left, right, up, down)

func _ready() -> void:
	var camera := get_tree().get_first_node_in_group("Camera")
	self.connect("call_new_screen", Callable(camera, "_on_link_call_new_screen"))
	pass

func _process(delta: float) -> void:
	current_attacked_iframes -= delta
	var new_screen_check : Vector2 = check_for_new_screen()
	if(!GameSettings.camera_is_moving):
		if (new_screen_check == Vector2.ZERO):
			if(is_attacked_knockback): 
				return
			calculate_movement(false)
			move_and_slide()
			$"Link Sprite"._on_character_body_2d_move_velocity(movement)
			$"Attack Area"._on_link_move_velocity(movement)
			check_attack()
		else:
			$"Link Sprite"._on_character_body_2d_move_velocity(movement)
			$"Attack Area"._on_link_move_velocity(movement)
			call_new_screen.emit(new_screen_check)
	else:
		keep_player_in_screen()
		
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
		is_attacking = true
		$"Link Sprite"._on_character_body_2d_attack()
		$"Attack Area"._on_link_attack()
		$AudioPlayer.stream = sword_swing_sound
		$AudioPlayer.play()


func _on_animated_sprite_2d_attack_ended() -> void:
	is_attacking = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Enemy") or area.is_in_group("Enemy_Attack")):
		attacked(area.global_position)


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
