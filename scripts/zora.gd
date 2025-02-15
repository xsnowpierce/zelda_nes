extends "res://scripts/enemy_ai.gd"

## X,Y is the top left point of the square, while Z,W is the bottom right point of the square.
var movable_tile_range : Array[Vector4]
@export var zora_projectile_scene : PackedScene

enum ZORA_STATE {UNDERWATER, ABOVEWATER}
var stay_underwater_after_time : float = 1
var stay_underwater_before_time : float = 0.2
var stay_abovewater_before_shoot_time : float = 0.4
var projectile_hold_on_zora_time : float = 0.2
var stay_abovewater_after_shoot_time : float = 0.4
var current_state : ZORA_STATE = ZORA_STATE.UNDERWATER
var current_projectile : Node

func _ready() -> void:
	super()
	loop()

func loop() -> void:
	while true:
		# pick a new location and wait to pop up
		global_position = pick_random_new_tile()
		$AnimatedSprite2D.play("under_water")
		current_state = ZORA_STATE.UNDERWATER
		await get_tree().create_timer(stay_underwater_before_time).timeout
	
		# pop up and wait to shoot
		$AnimatedSprite2D.play("above_water")
		current_state = ZORA_STATE.ABOVEWATER
		await get_tree().create_timer(stay_abovewater_before_shoot_time).timeout
	
		# spawn projectile now and hold onto it
		spawn_projectile()
		await get_tree().create_timer(projectile_hold_on_zora_time).timeout
	
		# shoot projectile and start timer to go back underwater
		# TODO change this precise angle to 8 directions only, to be accurate.
		var direction_to_link : Vector2 = (global_position - link.global_position).normalized()
		if(is_instance_valid(current_projectile)):
			current_projectile.set_forward_vector(-direction_to_link)
		await get_tree().create_timer(stay_abovewater_after_shoot_time).timeout
	
		# go underwater and wait to loop
		$AnimatedSprite2D.play("under_water")
		current_state = ZORA_STATE.UNDERWATER
		await get_tree().create_timer(stay_underwater_after_time).timeout
		while(is_instance_valid(current_projectile)): # make sure our current ball has despawned before we move
			await get_tree().process_frame

func attacked() -> void:
	if(current_state == ZORA_STATE.UNDERWATER):
		return
	else:
		super()

func death() -> void:
	if(is_instance_valid(current_projectile)):
		current_projectile.queue_free()
	super()

func pick_random_new_tile() -> Vector2:
	var target_position : Vector2
	while true:
		var use_array_index = randi_range(0, movable_tile_range.size() - 1)
		var pre_target_position = Vector2(randi_range(movable_tile_range[use_array_index].z, movable_tile_range[use_array_index].x), randi_range(movable_tile_range[use_array_index].w, movable_tile_range[use_array_index].y))
		target_position = Utils.align_to_grid(pre_target_position)
	
		# cast ray to see if we can go here
		if(Utils.check_position_for_colliders(target_position, collision_layers_bitmask, get_world_2d())):
			break
	return target_position

func spawn_projectile() -> void:
	if(is_instance_valid(current_projectile)):
		current_projectile.queue_free()
	current_projectile = zora_projectile_scene.instantiate()
	get_parent().add_child(current_projectile)
	current_projectile.global_position = global_position
	current_projectile.set_forward_vector(Vector2.ZERO)
