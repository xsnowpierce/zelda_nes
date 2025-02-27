extends Node2D

@export var fire_move_speed : float = 27
@export var fire_move_time : float = 0.6
@export_flags_2d_physics var collision_layers_bitmask
var has_collided_with_ground : bool
@export var idle_time_until_death : float = 1

func initialize_fire(direction : Vector2) -> void:
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.FIRE_SHOT)
	move_to_direction(direction)
	
func move_to_direction(target_direction : Vector2) -> void:
	if(target_direction != Vector2.ZERO):
		var move_time : float = fire_move_time
		while (move_time > 0 && !has_collided_with_ground):
			var move_distance = fire_move_speed * get_process_delta_time()
			global_position += target_direction * move_distance
			move_time -= get_process_delta_time()
			await get_tree().process_frame
	start_killing()
	
func start_killing() -> void:
	await get_tree().create_timer(idle_time_until_death).timeout
	queue_free()

func _on_area_2d_body_entered(body : Node2D) -> void:
	if(body.is_in_group("Ground")):
		has_collided_with_ground = true
