extends "res://scripts/enemy_ai.gd"

## X,Y is the top left point of the square, while Z,W is the bottom right point of the square.
@export var movable_tile_range : Array[Vector4]
@export var zora_projectile_scene : PackedScene

enum ZORA_STATE {UNDERWATER, ABOVEWATER}
var stay_underwater_after_time : float = 1
var stay_underwater_before_time : float = 0.2
var stay_abovewater_before_shoot_time : float = 0.4
var projectile_hold_on_zora_time : float = 0.2
var stay_abovewater_after_shoot_time : float = 0.4
var current_state : ZORA_STATE = ZORA_STATE.UNDERWATER

func _ready() -> void:
	super()
	loop()

func loop() -> void:
	while true:
		# pick a new location and wait to pop up
		global_position = pick_random_new_tile()
		$AnimatedSprite2D.play("under_water")
		current_state = ZORA_STATE.UNDERWATER
		var underwater_time_counter : float = stay_underwater_before_time
		while underwater_time_counter > 0:
			underwater_time_counter -= get_process_delta_time()
			await get_tree().process_frame
	
		# pop up and wait to shoot
		$AnimatedSprite2D.play("above_water")
		current_state = ZORA_STATE.ABOVEWATER
		var shoot_delay_timer : float = stay_abovewater_before_shoot_time
		while shoot_delay_timer > 0:
			shoot_delay_timer -= get_process_delta_time()
			await get_tree().process_frame
	
		# spawn projectile now and hold onto it
		var spawned_projectile = spawn_projectile()
		var projectile_hold_timer : float = projectile_hold_on_zora_time
		while projectile_hold_timer > 0:
			projectile_hold_timer -= get_process_delta_time()
			await get_tree().process_frame
	
		# shoot projectile and start timer to go back underwater
		# TODO change this precise angle to 8 directions only, to be accurate.
		var direction_to_link : Vector2 = (global_position - link.global_position).normalized()
		if(is_instance_valid(spawned_projectile)):
			spawned_projectile.set_forward_vector(-direction_to_link)
		var stay_abovewater_time : float = stay_abovewater_after_shoot_time
		while stay_abovewater_time > 0:
			stay_abovewater_time -= get_process_delta_time()
			await get_tree().process_frame
	
		# go underwater and wait to loop
		$AnimatedSprite2D.play("under_water")
		current_state = ZORA_STATE.UNDERWATER
		var reset_timer : float = stay_underwater_after_time
		while reset_timer > 0:
			reset_timer -= get_process_delta_time()
			await get_tree().process_frame


func pick_random_new_tile() -> Vector2:
	var target_position : Vector2
	while true:
		var use_array_index = randi_range(0, movable_tile_range.size() - 1)
		var pre_target_position = Vector2(randi_range(movable_tile_range[use_array_index].z, movable_tile_range[use_array_index].x), randi_range(movable_tile_range[use_array_index].w, movable_tile_range[use_array_index].y))
		target_position = Utils.align_to_grid(pre_target_position)
		print(use_array_index, pre_target_position, target_position)
	
		# cast ray to see if we can go here
		var space : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var parameters = PhysicsPointQueryParameters2D.new()
		parameters.position = target_position + Vector2(8,8) # add 8 to get centre of point
		parameters.collide_with_areas = true
		parameters.collide_with_bodies = true
		parameters.collision_mask = collision_layers_bitmask
		var result : Array[Dictionary] = space.intersect_point(parameters)
		if(!result.is_empty()):
			break
	return target_position

func spawn_projectile() -> Node2D:
	var projectile : Node2D = zora_projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.set_forward_vector(Vector2.ZERO)
	return projectile
