extends Node

var colliding_with_door : Area2D
signal entering_door(door : Area2D, leads_to_hyrule : bool)
@export var pickup_animation_length : float = 2.5
var player : CharacterBody2D
signal key_item_pickup_sound
signal door_enter_sound

func initialize(parent: CharacterBody2D) -> void:
	player = parent

func process(delta : float) -> void:
	if(colliding_with_door != null):
		check_door_collision()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("EntranceDoor") and (!player.get_player_state().is_entering_door and !player.get_player_state().is_exiting_door)):
		colliding_with_door = area

func _on_area_2d_area_exited(area: Area2D) -> void:
	if(area.is_in_group("EntranceDoor")):
		colliding_with_door = null

func picked_up_key_item(type : ENUM.KEY_ITEM_TYPE) -> void:
	player.game_data.player_pickup_key_item(type)
	key_item_pickup_sound.emit()
	player.get_player_state().is_pickup_animation = true
	var current_animation = player.get_sprite().animation
	player.get_sprite().play("item_pickup")
	await get_tree().create_timer(pickup_animation_length).timeout
	player.get_sprite().animation = current_animation
	player.get_player_state().is_pickup_animation = false

func check_door_collision() -> void:
	var grid_position = player.position - Vector2(8,8)
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
		if(player.get_player_state().is_inside_room):
			exit_door()
		else:
			enter_door()

func enter_door() -> void:
	if(player.get_player_state().is_entering_door or player.get_player_state().is_exiting_door):
		return
	player.get_player_state().is_entering_door = true
	player.position = (colliding_with_door.global_position + Vector2(8,8))
	entering_door.emit(colliding_with_door, true)
	player.game_data.player_start_enter_door(colliding_with_door)
	door_enter_sound.emit()
	var start_sprite_y : float = player.get_sprite().position.y
	await enter_door_sprite_animation()
	player.game_data.player_finish_enter_door(colliding_with_door)
	player.get_sprite_mask().clip_contents = false
	player.get_sprite().position.y = start_sprite_y
	player.get_player_state().is_inside_room = true
	player.get_player_state().is_entering_door = false
	
func wait_for_room_events() -> void:
	player.get_player_state().has_room_events = true
	
func finish_room_events() -> void:
	player.get_player_state().has_room_events = false
	
func exit_door() -> void:
	if(player.get_player_state().is_exiting_door or player.get_player_state().is_entering_door):
		return
	player.get_player_state().is_exiting_door = true
	player.game_data.player_finish_enter_door(colliding_with_door)
	door_enter_sound.emit()
	var start_sprite_y : float = player.get_sprite().position.y
	
	await exit_door_sprite_animation()
	player.get_sprite_mask().clip_contents = false
	player.get_sprite().position.y = start_sprite_y
	player.get_player_state().is_inside_room = false
	player.get_player_state().is_exiting_door = false
	
func enter_door_sprite_animation() -> void:
	var target_position : float = 24
	var pixel_drop_speed : float = 15
	player.get_sprite().play("up")
	player.get_sprite_mask().clip_contents = true
	while player.get_sprite().position.y < target_position:
		player.get_sprite().position.y += get_process_delta_time() * pixel_drop_speed
		await get_tree().process_frame
	player.get_sprite().pause()

func exit_door_sprite_animation() -> void:
	var target_position : float = 8
	var pixel_rise_speed : float = 15
	player.get_sprite().position.y = 24
	player.get_sprite().play("down")
	player.get_sprite_mask().clip_contents = true
	while player.get_sprite().position.y > target_position:
		player.get_sprite().position.y -= get_process_delta_time() * pixel_rise_speed
		await get_tree().process_frame
	player.get_sprite().pause()
