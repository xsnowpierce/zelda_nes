extends "res://scripts/enemy_ai.gd"

@export var random_shoot_time_range : Vector2 = Vector2(1.5,2.5)
@export var rotate_chance : float = 0.5
@export var move_speed : float = 23
@export var shoot_delay_time : float = 0.3
@export var post_shoot_delay_move_time : float = 0.1
var projectile_scene : PackedScene = load("res://scenes/octorok_rock.tscn")
var current_shoot_time : float
var current_forward_vector : Vector2
var is_moving : bool = false
var is_shooting : bool = false

func _ready() -> void:
	super()
	rotate_octorok(get_random_rotate_direction())
	current_shoot_time = randf_range(random_shoot_time_range.x, random_shoot_time_range.y)

func _process(delta: float) -> void:
	super(delta)
	if(GameSettings.camera_is_moving):
		return
	current_shoot_time -= delta
	if(current_shoot_time <= 0):
		shoot_projectile()
		current_shoot_time = randf_range(random_shoot_time_range.x, random_shoot_time_range.y)
	if(!is_moving and !is_shooting):
		try_rotate()
		move()
		

func try_rotate() -> void:
	if(randf_range(0, 1) > rotate_chance):
		rotate_octorok(get_random_rotate_direction())
	pass

func move() -> void:
	if(is_moving):
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
	if(Utils.is_out_of_bounds(get_target_position_from_direction(target_direction), camera)):
		return false
	
	match target_direction:
		Vector2.UP:
			if($TopCollider.collider_count <= 0):
				return true
		Vector2.DOWN:
			if($BottomCollider.collider_count <= 0):
				return true
		Vector2.LEFT:
			if($LeftCollider.collider_count <= 0):
				return true
		Vector2.RIGHT:
			if($RightCollider.collider_count <= 0):
				return true
	return false

func get_target_position_from_direction(target_direction : Vector2) -> Vector2:
	var target_position = (target_direction * 16) + position
	target_position = Utils.align_to_grid(target_position)
	return target_position

func move_to_direction(target_direction : Vector2) -> void:
	rotate_octorok(target_direction)
	var target_position = get_target_position_from_direction(target_direction)
	
		# move to position
	while (position.distance_to(target_position) > 1):
		if(is_shooting or GameSettings.camera_is_moving or !can_process()):
			await get_tree().process_frame
			continue
		var move_distance = move_speed * get_process_delta_time()  # Distance to move this frame
		position = position.move_toward(target_position, move_distance)  # Move at constant speed
		await get_tree().process_frame
		
	position = target_position
	is_moving = false
		
func shoot_projectile() -> void:
	is_shooting = true
	var current_shoot_delay_time = shoot_delay_time
	while current_shoot_delay_time > 0:
		current_shoot_delay_time -= get_process_delta_time()
		await get_tree().process_frame
	spawn_projectile()
	var current_post_delay : float = post_shoot_delay_move_time
	while current_post_delay > 0:
		current_post_delay -= get_process_delta_time()
		await get_tree().process_frame
	is_shooting = false

func spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.position = position + (current_forward_vector * 16)
	projectile.set_forward_vector(current_forward_vector)

func rotate_octorok(direction : Vector2):
	match direction:
		Vector2.UP:
			$AnimatedSprite2D.play("up")
		Vector2.DOWN:
			$AnimatedSprite2D.play("down")
		Vector2.LEFT:
			$AnimatedSprite2D.play("left")
		Vector2.RIGHT:
			$AnimatedSprite2D.play("right")
	current_forward_vector = direction

func get_random_rotate_direction() -> Vector2:
	var random_number = randf_range(0, 1)
	if random_number >= 0.75:
		return Vector2.RIGHT
	if random_number < 0.75 and random_number >= 0.5:
		return Vector2.LEFT
	if random_number < 0.5 and random_number >= 0.25:
		return Vector2.DOWN
	else:
		return Vector2.UP
