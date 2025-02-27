extends EnemyAI

enum Phase { ASCEND, DECELERATE, DESCEND }

@export var jump_ascend_strength: float = 2
@export var jump_descend_strength: float = -2
@export var jump_deceleration_speed: float = 2
@export var jump_horizontal_speed: float = 1
@export var jump_speed: float = 60
@export var jump_speed_duration_multiplier: float = 0.2
@export var random_idle_time_range: Vector2 = Vector2(1, 3)
@export var jump_chargeup_time : float = 0.5

var current_jump_direction: int = 1
var jump_active: bool = false
var force_downwards_jump = false
var camera_has_moved : bool

func _ready() -> void:
	super()
	loop()

func _process(delta: float) -> void:
	super(delta)
	if(GameSettings.camera_is_moving):
		camera_has_moved = true

func loop() -> void:
	while true:
		$AnimatedSprite2D.play("default")
		await get_tree().create_timer(randf_range(random_idle_time_range.x, random_idle_time_range.y)).timeout
		current_jump_direction = 1 if randi() % 2 else -1
		$AnimatedSprite2D.pause()
		$AnimatedSprite2D.frame = 0
		await get_tree().create_timer(jump_chargeup_time).timeout
		$AnimatedSprite2D.frame = 1
		await jump()

func jump() -> void:
	jump_active = true
	
	var phase = Phase.ASCEND

	var jump_ascend_time = randi_range(1, 3)
	if force_downwards_jump:
		jump_ascend_time = 0
	var jump_descend_time = randi_range(0, 3)
	var jump_current_power = jump_ascend_strength
	var delta = get_process_delta_time()
	var velocity: Vector2

	if (global_position + Vector2(8, 8)).y > GameSettings.screen_boundaries.w - 16:
		jump_ascend_time += 2
	
	while jump_active:
		while get_tree().paused:
			await get_tree().process_frame
		
		match phase:
			Phase.ASCEND:
				if jump_ascend_time > 0:
					jump_ascend_time -= delta * jump_speed * jump_speed_duration_multiplier
					velocity = Vector2(jump_horizontal_speed * current_jump_direction, -jump_current_power)
				else:
					phase = Phase.DECELERATE

			Phase.DECELERATE:
				if jump_current_power > jump_descend_strength:
					jump_current_power -= delta * jump_speed * jump_speed_duration_multiplier * jump_deceleration_speed
					velocity = Vector2(jump_horizontal_speed * current_jump_direction, -jump_current_power)
				else:
					phase = Phase.DESCEND
					if (global_position + Vector2(8, 8)).y < GameSettings.screen_boundaries.z + 16:
						jump_descend_time += 2

			Phase.DESCEND:
				if jump_descend_time > 0:
					jump_descend_time -= delta * jump_speed * jump_speed_duration_multiplier
					velocity = Vector2(jump_horizontal_speed * current_jump_direction, -jump_descend_strength)
				else:
					jump_active = false

		position += velocity * delta * jump_speed

		if camera_has_moved:
			break
		if check_bounds():
			jump()
			return
		if phase == Phase.DESCEND and (global_position + Vector2(8, 8)).y > GameSettings.screen_boundaries.w - 16:
			break

		await get_tree().process_frame


func check_bounds() -> bool:
	if(!GameSettings.camera_is_moving):
		if(deal_with_out_of_bounds()):
			jump()
			return true
	return false

func deal_with_out_of_bounds() -> bool:
	var position_offset := global_position + Vector2(8, 8)
	if(Utils.is_out_of_bounds_x(position_offset, camera, true)):
		current_jump_direction = -current_jump_direction
		return true
	return false
	
