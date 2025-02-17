extends Node

@export var player_flags : Array[String]
@export_flags_2d_render var camera_cull_mask

@export_group("Enemy Scenes")
@export var enemy_tektite_scene : PackedScene
@export var enemy_octorok_scene : PackedScene
@export var enemy_zora_scene : PackedScene
@export var enemy_leever_scene : PackedScene

@export_group("Player Stats")
@export_subgroup("Health")
@export var max_player_health : int = 6
@export var current_player_health : int = 4
@export_subgroup("Rupees")
@export var max_rupees : int = 255
@export var current_rupees : int = 0
@export_subgroup("Keys")
@export var max_keys : int = 255
@export var current_keys : int = 0
@export_subgroup("Bombs")
@export var max_bombs : int = 8
@export var current_bombs : int = 0

@export_group("Music Files")
@export var hyrule_music : AudioStreamWAV

var current_area : Node2D
var camera : Camera2D
var link : CharacterBody2D
var current_equipped_item_a : ENUM.KEY_ITEM_TYPE = ENUM.KEY_ITEM_TYPE.NULL
var current_equipped_item_b : ENUM.KEY_ITEM_TYPE = ENUM.KEY_ITEM_TYPE.NULL
var game_is_paused : bool
@export var enemy_spawn_parent : Node2D

signal player_death
signal player_health_changed(new_current_amount : int)
signal player_max_health_changed(new_max_amount : int)
signal rupees_changed(new_current_amount : int)
signal keys_changed(new_current_amount : int)
signal bombs_changed(new_current_amount : int)
signal max_bombs_changed(new_max_amount : int)
signal pause_menu_opened
signal pause_menu_closed
signal equipment_slot_a_changed(new_item_type : ENUM.KEY_ITEM_TYPE)
signal equipment_slot_b_changed(new_item_type : ENUM.KEY_ITEM_TYPE)

func _ready() -> void:
	get_tree().root.get_viewport().canvas_cull_mask = camera_cull_mask
	camera = get_tree().get_first_node_in_group("Camera")
	link = get_tree().get_first_node_in_group("Player")
	player_max_health_changed.emit(max_player_health)
	player_health_changed.emit(current_player_health)
	rupees_changed.emit(current_rupees)
	keys_changed.emit(current_keys)
	bombs_changed.emit(current_bombs)
	max_bombs_changed.emit(max_bombs)
	var camera_position = Vector2i(roundi($SPAWNPOINT.global_position.x / GameSettings.map_screen_size.x), roundi($SPAWNPOINT.global_position.y / GameSettings.map_screen_size.y))
	camera.set_camera_tile(camera_position)
	link.position = $SPAWNPOINT.global_position

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("pause_game")):
		if(camera.is_currently_moving or camera.is_currently_moving_pause_menu):
			return
		if(game_is_paused):
			close_pause_menu()
		else:
			open_pause_menu()

func has_player_flag(flag : String) -> bool:
	if(player_flags.has(flag)):
		return true
	return false

func add_player_flag(flag : String) -> void:
	if(!player_flags.has(flag)):
		player_flags.append(flag)

func remove_player_flag(flag : String) -> void:
	if(player_flags.has(flag)):
		player_flags.erase(flag)

func player_took_damage(damage : int) -> void:
	player_lose_health(damage)
	if(current_player_health <= 0):
		player_death.emit()

func player_gain_heart(amount : int) -> void:
	current_player_health += amount
	player_health_changed.emit(current_player_health)

func player_lose_health(amount : int) -> void:
	current_player_health -= amount
	player_health_changed.emit(current_player_health)

func change_max_hearts(amount : int) -> void:
	max_player_health += amount
	if(current_player_health > max_player_health):
		current_player_health = max_player_health
	player_max_health_changed.emit(max_player_health)

func change_rupees(amount : int) -> void:
	current_rupees += amount
	rupees_changed.emit(current_rupees)

func change_keys(amount : int) -> void:
	current_keys += amount
	keys_changed.emit(current_keys)

func change_bombs(amount : int) -> void:
	current_bombs += amount
	bombs_changed.emit(current_bombs)

func change_max_bombs(amount : int) -> void:
	max_bombs += amount
	max_bombs_changed.emit(max_bombs)

func player_start_enter_door(_door : Area2D) -> void:
	$MusicPlayer.stop()

func player_finish_enter_door(door : Area2D) -> void:
	camera.set_camera_tile(door.camera_move_to_tile_coordinate)
	link.position = door.link_move_to_position
	if door.area_data.get_area_type() == "room_data":
		print("was room_data")
		if(door.area_data != null):
			link.wait_for_room_events()
			current_area = door.area_data
			while(!current_area.is_loaded):
				await get_tree().process_frame
			link.finish_room_events()
	while(link.is_exiting_door):
		await get_tree().process_frame
	$MusicPlayer.stream = door.area_data.area_music
	$MusicPlayer.play(0.0)

func player_pickup_key_item(item_type : ENUM.KEY_ITEM_TYPE) -> void:
	match item_type:
		ENUM.KEY_ITEM_TYPE.WOODEN_SWORD:
			add_player_flag("obtained_wooden_sword")
			if(current_equipped_item_a == ENUM.KEY_ITEM_TYPE.NULL):
				equip_key_item(item_type, 1)
		ENUM.KEY_ITEM_TYPE.DOOR_KEY:
			current_keys += 1
			keys_changed.emit(current_keys)

func equip_key_item(type : ENUM.KEY_ITEM_TYPE, slot : int) -> void:
	if(slot == 0):
		# equip to B slot
		equipment_slot_b_changed.emit(type)
		current_equipped_item_b = type
		
	else:
		# equip to A slot
		equipment_slot_a_changed.emit(type)
		current_equipped_item_a = type

func open_pause_menu() -> void:
	if(game_is_paused):
		return
	print("paused")
	game_is_paused = true
	get_tree().paused = true
	pause_menu_opened.emit()
	camera.open_pause_menu()

func close_pause_menu() -> void:
	if(!game_is_paused):
		return
	await camera.close_pause_menu()
	game_is_paused = false
	get_tree().paused = false
	pause_menu_closed.emit()
