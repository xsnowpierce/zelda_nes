extends EnemyAI

class_name EnemyAI_Wander

@export var rotate_chance : float = 0.5
@export var move_speed : float = 23
var current_forward_vector : Vector2
var is_moving : bool = false
@export var rotate_sprite : bool = true

func _ready() -> void:
	super()
	rotate_enemy(get_rotate_direction())

func _process(delta: float) -> void:
	super(delta)
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
	
func can_move() -> bool:
	if GameSettings.camera_is_moving or !can_process():
		return false
	return true

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
	if(Utils.is_out_of_bounds(get_target_position_from_direction(target_direction), camera, true)):
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
	var target_position = (target_direction * 16) + global_position
	target_position = Utils.align_to_grid(target_position)
	return target_position

func move_to_direction(target_direction : Vector2) -> void:
	rotate_enemy(target_direction)
	var target_position = get_target_position_from_direction(target_direction)
	
		# move to position
	while (global_position.distance_to(target_position) > 1):
		if(!can_move()):
			await get_tree().process_frame
			continue
		var move_distance = move_speed * get_process_delta_time()  # Distance to move this frame
		global_position = global_position.move_toward(target_position, move_distance)  # Move at constant speed
		await get_tree().process_frame
		
	global_position = target_position
	is_moving = false

func rotate_enemy(direction : Vector2):
	if(!rotate_sprite):
		return
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

func get_rotate_direction() -> Vector2:
	var random_number = randf_range(0, 1)
	if random_number >= 0.75:
		return Vector2.RIGHT
	if random_number < 0.75 and random_number >= 0.5:
		return Vector2.LEFT
	if random_number < 0.5 and random_number >= 0.25:
		return Vector2.DOWN
	else:
		return Vector2.UP
