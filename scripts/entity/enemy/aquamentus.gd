extends EnemyAI

@export var move_left_pixel_limit : int = 0
@export var move_right_pixel_limit : int = 72

var fireball_01_direction : float = -20
var fireball_02_direction : float = 0
var fireball_03_direction : float = 20
var fireball_scene : PackedScene = load("res://scenes/enemy_scenes/aquamentus_ball.tscn")

@export var move_speed : float = 7.5
@export var random_shoot_timer : Vector2 = Vector2(1, 3)
@export var random_innacuracy_range_degrees : Vector2 = Vector2(-5, 5)
@export var shoot_delay : float = 0.4
@export var roar_sound_delay : float = 3
var current_shoot_timer : float
var is_shooting : bool
var move_hit_left_bounds : bool
var move_hit_right_bounds : bool

func _ready() -> void:
	super()
	current_shoot_timer = randf_range(random_shoot_timer.x, random_shoot_timer.y)
	play_roar_sound()
	await get_tree().process_frame
	movement()

func _process(delta: float) -> void:
	super(delta)
	current_shoot_timer -= delta
	if(current_shoot_timer <= 0 and !is_shooting):
		shoot_projectile()

func play_hurt_sound() -> void:
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.AQUAMENTUS_HURT)

func play_death_sound() -> void:
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.AQUAMENTUS_HURT)

func movement() -> void:
	while true:
		var move_distance = randi_range(0, 1)
		if(move_distance == 0):
			move_distance = 8
		else:
			move_distance = 16
		var random_direction = randi_range(0, 1) # 0 is left, 1 is right
		await move_to_position(random_direction, move_distance)
		

func move_to_position(target_direction : int, move_distance : int) -> void:
	if(target_direction == 0):
		target_direction = -1
		
	if(move_hit_left_bounds):
		target_direction = 1
	elif(move_hit_right_bounds):
		target_direction = -1
	
	move_hit_left_bounds = false
	move_hit_right_bounds = false
	
	var target_position = get_target_position(target_direction, move_distance)
		# move to position
	while (global_position.distance_to(target_position) > 1):
		if(!can_move()):
			await get_tree().process_frame
			continue
		var relative_position = global_position - camera.global_position
		global_position = global_position.move_toward(target_position, move_speed * get_process_delta_time())
		if(relative_position.x < move_left_pixel_limit):
			move_hit_left_bounds = true
			global_position = Vector2(camera.global_position.x + move_left_pixel_limit, global_position.y)
			break
		elif(relative_position.x > move_right_pixel_limit):
			move_hit_right_bounds = true
			global_position = Vector2(camera.global_position.x + move_right_pixel_limit, global_position.y)
			break
		await get_tree().process_frame
	
func get_target_position(target_direction : int, move_distance : int) -> Vector2:
	return global_position + Vector2(target_direction * move_distance, 0)

func shoot_projectile() -> void:
	is_shooting = true
	$AnimatedSprite2D.play("mouth_open")
	await get_tree().create_timer(shoot_delay).timeout
	$AnimatedSprite2D.play("default")
	
	var fireball_directions = [fireball_01_direction, fireball_02_direction, fireball_03_direction]
	var spawn_pos = $"Projectile Spawn Spot".global_position
	var target_pos = link.global_position
	
	var direction = (target_pos - spawn_pos).normalized()
	var base_angle = (rad_to_deg(atan2(direction.y, direction.x)) + 90 + 
		randi_range(random_innacuracy_range_degrees.x, random_innacuracy_range_degrees.y))
	
	for offset in fireball_directions:
		var fireball = fireball_scene.instantiate()
		get_parent().add_child(fireball)
		fireball.global_position = spawn_pos
		fireball.set_forward_vector(Utils.degrees_to_vector(base_angle + offset))

	current_shoot_timer = randf_range(random_shoot_timer.x, random_shoot_timer.y)
	is_shooting = false

func play_roar_sound() -> void:
	while true:
		get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.AQUAMENTUS_ROAR)
		await get_tree().create_timer(roar_sound_delay).timeout
