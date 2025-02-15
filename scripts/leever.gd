extends "res://scripts/enemy_ai.gd"

enum LEEVER_STATE {ABOVEGROUND, UNDERGROUND}
var current_state : LEEVER_STATE
@export var spawn_from_link_offset : int = 2
@export var move_speed : float = 23
var hit_link : bool = false
var towards_link_direction : Vector2
var is_moving : bool

func _ready() -> void:
	super()
	loop()
	
func loop() -> void:
	while true:
		# reset variables
		hit_link = false
		
		# check to see if we can spawn
		var spawn_position: Vector2 = get_spawn_position()
		while spawn_position == Vector2.INF:
			# we can't spawn, delay loop until we can
			spawn_position = get_spawn_position()
			await get_tree().process_frame
			
		# spawn the leever in the appropriate spot, and rise from the ground
		global_position = spawn_position
		current_state = LEEVER_STATE.UNDERGROUND
		$AnimatedSprite2D.play("rising")
		while $AnimatedSprite2D.is_playing():
			await get_tree().process_frame
		
		# move towards links position until we either hit link, or a wall
		current_state = LEEVER_STATE.ABOVEGROUND
		$AnimatedSprite2D.play("spinning")
		while check_if_move_is_valid(towards_link_direction):
			if(!is_moving):
				move()
				while is_moving:
					await get_tree().process_frame
		
		# if we hit a wall, go underground
		if(!check_if_move_is_valid(towards_link_direction)):
			$AnimatedSprite2D.play("sinking")
			while $AnimatedSprite2D.is_playing():
				await get_tree().process_frame
			current_state = LEEVER_STATE.UNDERGROUND
		
func get_spawn_position() -> Vector2:
	var link_position: Vector2 = link.global_position - Vector2(8, 8) # change to the vector to get proper alignment
	var link_facing_direction  = link.get_look_direction() * spawn_from_link_offset * 16
	var spawn_position = Utils.align_to_grid(link_position + link_facing_direction, 8)
	towards_link_direction = -link.get_look_direction()
	if(!Utils.check_position_for_colliders(spawn_position, collision_layers_bitmask, get_world_2d())):
		return spawn_position
	else:
		link_facing_direction = -link.get_look_direction() * spawn_from_link_offset * 16
		spawn_position = Utils.align_to_grid(link_position + link_facing_direction, 8)
		towards_link_direction = link.get_look_direction()
		if(!Utils.check_position_for_colliders(spawn_position, collision_layers_bitmask, get_world_2d())):
				return spawn_position
		else:
			return Vector2.INF

func move() -> void:
	if(is_moving):
		return
	is_moving = true
	if(check_if_move_is_valid(towards_link_direction)):
		move_to_direction(towards_link_direction)
	else:
		is_moving = false
		return

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
	var target_position = (target_direction * 8) + position
	target_position = Utils.align_to_grid(target_position, 8)
	return target_position

func move_to_direction(target_direction : Vector2) -> void:
	var target_position = get_target_position_from_direction(target_direction)
	
		# move to position
	while (position.distance_to(target_position) > 1):
		if(hit_link):
			target_direction = -target_direction
			towards_link_direction = target_direction
			target_position = get_target_position_from_direction(target_direction)
			hit_link = false
		if(GameSettings.camera_is_moving):
			await get_tree().process_frame
			continue
		var move_distance = move_speed * get_process_delta_time()  # Distance to move this frame
		position = position.move_toward(target_position, move_distance)  # Move at constant speed
		await get_tree().process_frame
	
	position = target_position
	is_moving = false

func attacked() -> void:
	if(current_state == LEEVER_STATE.UNDERGROUND):
		return
	else:
		super()

func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Player")):
		hit_link = true
	else:
		super(area)
