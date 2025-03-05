extends Node

class_name GameData

@export var player_flags : Array[String]
@export_flags_2d_render var camera_cull_mask

@export_group("Enemy Scenes")
@export var enemy_tektite_scene : PackedScene
@export var enemy_octorok_scene : PackedScene
@export var enemy_zora_scene : PackedScene
@export var enemy_leever_scene : PackedScene
@export var enemy_blue_tektite_scene : PackedScene
@export var enemy_peahat_scene : PackedScene
@export var enemy_keese_scene : PackedScene
@export var enemy_stalfos_scene : PackedScene
@export var enemy_gel_scene : PackedScene
@export var enemy_blade_trap_scene : PackedScene
@export var enemy_goriya_scene : PackedScene
@export var boss_aquamentus_scene : PackedScene

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

# NULL,WOODEN_SWORD, WHITE_SWORD, MAGICAL_SWORD, 
	#WOODEN_SHIELD,MAGICAL_SHIELD,WOODEN_BOOMERANG,MAGICAL_BOOMERANG,
	#BOMB,BOW,WOODEN_ARROW,SILVER_ARROW,BLUE_CANDLE,RED_CANDLE,RECORDER,
	#FOOD,LETTER,RED_POTION,BLUE_POTION,MAGICAL_ROD,DOOR_KEY, HEART_CONTAINER
@export_subgroup("Key Items")
@export var has_wooden_sword : bool
@export var has_white_sword : bool
@export var has_magical_sword : bool
@export var has_wooden_shield : bool
@export var has_magical_shield : bool
@export var has_wooden_boomerang : bool
@export var has_magical_boomerang : bool
@export var has_bomb : bool
@export var has_bow : bool
@export var has_wooden_arrow : bool
@export var has_silver_arrow : bool
@export var has_blue_candle : bool
@export var has_red_candle : bool
@export var has_recorder : bool
@export var has_food : bool
@export var has_letter : bool
@export var has_red_potion : bool
@export var has_blue_potion : bool
@export var has_magical_rod : bool

@export_subgroup("Dungeon Key Items")
@export var has_eagle_compass : bool
@export var has_eagle_map : bool

func apply_debug_key_item_list() -> void:
	if(has_wooden_sword):
		add_player_flag("obtained_wooden_sword")
	if(has_white_sword):
		add_player_flag("obtained_white_sword")
	if(has_magical_sword):
		add_player_flag("obtained_magical_sword")
	if(has_wooden_shield):
		add_player_flag("obtained_wooden_shield")
	if(has_magical_shield):
		add_player_flag("obtained_magical_shield")
	if(has_wooden_boomerang):
		add_player_flag("obtained_wooden_boomerang")
	if(has_magical_boomerang):
		add_player_flag("obtained_magical_boomerang")
	if(has_bomb):
		add_player_flag("obtained_bomb")
	if(has_bow):
		add_player_flag("obtained_bow")
	if(has_wooden_arrow):
		add_player_flag("obtained_wooden_arrows")
	if(has_silver_arrow):
		add_player_flag("obtained_silver_arrows")
	if(has_blue_candle):
		add_player_flag("obtained_blue_candle")
	if(has_red_candle):
		add_player_flag("obtained_red_candle")
	if(has_recorder):
		add_player_flag("obtained_whistle")
	if(has_food):
		add_player_flag("obtained_food")
	if(has_letter):
		add_player_flag("obtained_letter")
	if(has_red_potion):
		add_player_flag("obtained_red_potion")
	if(has_blue_potion):
		add_player_flag("obtained_blue_potion")
	if(has_magical_rod):
		add_player_flag("obtained_magic_rod")

@export_group("Music Files")
@export var hyrule_music : AudioStreamWAV
@export var dungeon_music : AudioStreamWAV

var current_area : Node2D
var camera : Camera2D
var link : LinkController
@export_group("")
@export var current_equipped_item_a : ENUM.KEY_ITEM_TYPE = ENUM.KEY_ITEM_TYPE.NULL
@export var current_equipped_item_b : ENUM.KEY_ITEM_TYPE = ENUM.KEY_ITEM_TYPE.NULL
var game_is_paused : bool
var link_using_whistle : bool
var is_inside_dungeon : bool
@export var dropped_item_scene : PackedScene = preload("res://scenes/dropped_item.tscn")

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
signal pause_menu_control(given_control : bool)

func _ready() -> void:
	apply_debug_key_item_list()
	get_tree().root.get_viewport().canvas_cull_mask = camera_cull_mask
	camera = get_tree().get_first_node_in_group("Camera")
	link = get_tree().get_first_node_in_group("Player")
	player_max_health_changed.emit(max_player_health)
	player_health_changed.emit(current_player_health)
	rupees_changed.emit(current_rupees)
	keys_changed.emit(current_keys)
	bombs_changed.emit(current_bombs)
	max_bombs_changed.emit(max_bombs)
	equipment_slot_a_changed.emit(current_equipped_item_a)
	equipment_slot_b_changed.emit(current_equipped_item_b)
	var camera_position = Vector2i(roundi($SPAWNPOINT.global_position.x / GameSettings.map_screen_size.x), roundi($SPAWNPOINT.global_position.y / GameSettings.map_screen_size.y))
	camera.set_camera_tile(camera_position)
	link.position = $SPAWNPOINT.global_position
	$INTERIOR_HANDLER.initialize(camera, link, self)

func _process(_delta: float) -> void:
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
	$RNG_DROPPER.link_was_hit()

func player_gain_heart(amount : int) -> void:
	current_player_health += amount
	if(current_player_health > max_player_health):
		current_player_health = max_player_health
	player_health_changed.emit(current_player_health)

func player_lose_health(amount : int) -> void:
	current_player_health -= amount
	if(current_player_health < 0):
		current_player_health = 0
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
	if(door is RoomEntrance):
		is_inside_dungeon = false
		$INTERIOR_HANDLER.handle_interior(door.interior_data)
		link.get_player_state().has_room_events = true
		while !$INTERIOR_HANDLER.player_has_input:
			await get_tree().process_frame
		link.get_player_state().has_room_events = false
	elif(door is HyruleEntrance):
		is_inside_dungeon = false
		link.global_position = door.link_moveto_position
		camera.set_camera_tile(door.camera_moveto_position)
		$MusicPlayer.stream = hyrule_music
		$MusicPlayer.play(0.0)
	elif(door is DungeonEntrance):
		if(door is DungeonRoomEntrance):
			$DUNGEON_KEY_ROOM.room_entered(door.dungeon_key_room_settings)
		else:
			link.get_player_state().ignore_force_tile_walks = true
			door.entrance_used.emit()
		is_inside_dungeon = true
		link.global_position = door.link_moveto_position
		link.get_sprite().current_direction = Vector2.DOWN
		camera.set_camera_tile(door.camera_moveto_position)
		if(!($MusicPlayer.stream == dungeon_music and $MusicPlayer.playing)):
			$MusicPlayer.stream = dungeon_music
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
		ENUM.KEY_ITEM_TYPE.HEART_CONTAINER:
			change_max_hearts(2)
			current_player_health = max_player_health
			player_health_changed.emit(current_player_health)

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
	if(game_is_paused or link_using_whistle):
		return
	game_is_paused = true
	get_tree().paused = true
	pause_menu_opened.emit()
	await camera.open_pause_menu()
	pause_menu_control.emit(true)

func close_pause_menu() -> void:
	if(!game_is_paused or link_using_whistle):
		return
	pause_menu_control.emit(false)
	await camera.close_pause_menu()
	game_is_paused = false
	get_tree().paused = false
	pause_menu_closed.emit()

func set_whistle_pause_value(value : bool) -> void:
	link_using_whistle = value
	get_tree().paused = value

func add_player_kill(enemy_type : ENUM.ENEMY_TYPE, kill_method : ENUM.KILL_METHOD) -> void:
	$RNG_DROPPER.add_kill(enemy_type, kill_method)

func enemy_drop_item(drop_position : Vector2) -> void:
	var next_drop : ENUM.ITEM_TYPE = $RNG_DROPPER.get_next_drop()
	print("get_drop called: ", ENUM.ITEM_TYPE.keys()[next_drop])
	if(next_drop == ENUM.ITEM_TYPE.NULL):
		return
	var dropped_item = dropped_item_scene.instantiate()
	dropped_item.global_position = drop_position
	dropped_item.set_item_type(next_drop)
	add_child(dropped_item)

func equipped_b_slot_change(new_item_type : ENUM.KEY_ITEM_TYPE) -> void:
	current_equipped_item_b = new_item_type

func picked_up_dungeon_compass() -> void:
	has_eagle_compass = true
