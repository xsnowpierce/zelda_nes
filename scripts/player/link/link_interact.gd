extends Node

var colliding_with_dungeon_door : DungeonDoor
var colliding_with_door : Area2D
var colliding_with_dungeon_door_interaction_deadzone : float = .2
signal entering_door(door : Area2D, leads_to_hyrule : bool)
@export var pickup_animation_length : float = 2.5
var player : LinkController
signal key_item_pickup_sound
signal door_enter_sound

func initialize(parent: LinkController) -> void:
	player = parent

func process(delta : float) -> void:
	if(colliding_with_door != null):
		check_door_collision()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.get_parent() is DungeonDoor):
		started_door_collision(area.get_parent())
	if(area.is_in_group("EntranceDoor") and (!player.get_player_state().is_entering_door and !player.get_player_state().is_exiting_door)):
		colliding_with_door = area
	elif(area.is_in_group("DroppedItem")):
		if(area.get_parent() is DroppedItem):
			var dropped_item : DroppedItem = area.get_parent()
			do_item_pickup(dropped_item)

func do_item_pickup(dropped_item : DroppedItem) -> void:
	match dropped_item.item_type:
		ENUM.ITEM_TYPE.GREEN_RUPEE:
			if(dropped_item.rupee_value_override != -1):
				player.player_data.change_rupees(dropped_item.rupee_value_override)
			else:
				player.player_data.change_rupees(1)
				player.player_data.get_sfx_player().play_sound(SFXPlayer.SFX.RUPEE_PICKUP)
		ENUM.ITEM_TYPE.BLUE_RUPEE:
			if(dropped_item.rupee_value_override != -1):
				player.player_data.change_rupees(dropped_item.rupee_value_override)
			else:
				player.player_data.change_rupees(5)
				player.player_data.get_sfx_player().play_sound(SFXPlayer.SFX.RUPEE_PICKUP)
		ENUM.ITEM_TYPE.HEART:
			player.player_data.player_gain_heart(2)
			player.player_data.get_sfx_player().play_sound(SFXPlayer.SFX.HEART_PICKUP)
		ENUM.ITEM_TYPE.DOOR_KEY:
			player.player_data.change_keys(1)
			player.player_data.get_sfx_player().play_sound(SFXPlayer.SFX.HEART_PICKUP)
		ENUM.ITEM_TYPE.COMPASS:
			player.player_data.picked_up_dungeon_compass()
			player.player_data.get_sfx_player().play_sound(SFXPlayer.SFX.HEART_PICKUP)
		ENUM.ITEM_TYPE.HEART_CONTAINER:
			player.player_data.change_max_hearts(2)
			player.player_data.get_sfx_player().play_sound(SFXPlayer.SFX.HEART_CONTAINER_PICKUP)
		ENUM.ITEM_TYPE.TRIFORCE_PIECE:
			pass
	if(dropped_item.is_key_item):
		player.player_data.add_player_flag(dropped_item.get_obtain_player_flag_from_item_type(dropped_item.item_type))
		player.player_data.player_pickup_key_item(dropped_item.item_type)
	dropped_item.item_picked_up.emit()
	dropped_item.queue_free()

func started_door_collision(door : DungeonDoor) -> void:
	if(door.current_door_status != door.DOOR_STATUS.LOCKED):
		return
	colliding_with_dungeon_door = door
	var colliding_time : float = 0
	while(colliding_with_dungeon_door != null):
		if(player.get_look_direction() == door.get_required_link_look_direction()):
			colliding_time += get_process_delta_time()
			if(colliding_time >= colliding_with_dungeon_door_interaction_deadzone):
				interact_with_door(door)
		else:
			colliding_time = 0
		await get_tree().process_frame

func interact_with_door(door : DungeonDoor):
	if(player.player_data.player_stats.current_keys >= 1):
		player.player_data.change_keys(-1)
		player.player_data.get_sfx_player().play_sound(SFXPlayer.SFX.DOOR_OPEN)
		door.set_door_status(DungeonDoor.DOOR_STATUS.OPEN)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if(area.get_parent() is DungeonDoor):
		colliding_with_dungeon_door = null
	if(area.is_in_group("EntranceDoor")):
		colliding_with_door = null

func picked_up_key_item(type : ENUM.ITEM_TYPE) -> void:
	player.get_pickup_item_sprite().set_item_type(type)
	player.get_pickup_item_sprite().visible = true
	key_item_pickup_sound.emit()
	player.get_player_state().is_pickup_animation = true
	var current_animation = player.get_sprite().animation
	if(player.get_pickup_item_sprite().is_wide_sprite):
		player.get_sprite().play("large_item_pickup")
	else:
		player.get_sprite().play("item_pickup")
	await get_tree().create_timer(pickup_animation_length).timeout
	player.get_sprite().animation = current_animation
	player.get_player_state().is_pickup_animation = false
	player.get_pickup_item_sprite().visible = false

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
	if(!colliding_with_door.is_staircase):
		player.get_player_state().is_entering_door = true
		player.position = (colliding_with_door.global_position + Vector2(8,8))
		entering_door.emit(colliding_with_door, true)
		player.player_data.player_start_enter_door(colliding_with_door)
		door_enter_sound.emit()
		var start_sprite_y : float = player.get_sprite().position.y
		await enter_door_sprite_animation()
		player.get_sprite_mask().clip_contents = false
		player.get_sprite().position.y = start_sprite_y
		player.get_player_state().is_inside_room = true
		player.get_player_state().is_entering_door = false
		
	player.player_data.player_finish_enter_door(colliding_with_door)
	
func wait_for_room_events() -> void:
	player.get_player_state().has_room_events = true
	
func finish_room_events() -> void:
	player.get_player_state().has_room_events = false
	
func exit_door() -> void:
	if(player.get_player_state().is_exiting_door or player.get_player_state().is_entering_door):
		return
	player.get_player_state().is_exiting_door = true
	player.player_data.player_finish_enter_door(colliding_with_door)
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
