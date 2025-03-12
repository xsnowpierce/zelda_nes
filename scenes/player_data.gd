extends Node

class_name PlayerData

var current_multiplayer_player_id : int = 1
var starting_tile_coordinate : Vector2
var link_starting_global_position : Vector2
var link_starting_direction : Vector2 = Vector2.UP

@export_flags_2d_render var camera_cull_mask

@export_group("Player Stats")
@export var player_stats : PlayerStats
@export var current_equipped_item_a : ENUM.ITEM_TYPE = ENUM.ITEM_TYPE.NULL
@export var current_equipped_item_b : ENUM.ITEM_TYPE = ENUM.ITEM_TYPE.NULL

var enemy_tektite_scene : PackedScene = load("res://scenes/enemy_scenes/tektite.tscn")
var enemy_octorok_scene : PackedScene = load("res://scenes/enemy_scenes/octorok.tscn")
var enemy_zora_scene : PackedScene = load("res://scenes/enemy_scenes/zora.tscn")
var enemy_leever_scene : PackedScene = load("res://scenes/enemy_scenes/leever.tscn")
var enemy_blue_tektite_scene : PackedScene = load("res://scenes/enemy_scenes/blue_tektite.tscn")
var enemy_peahat_scene : PackedScene = load("res://scenes/enemy_scenes/peahat.tscn")
var enemy_keese_scene : PackedScene = load("res://scenes/enemy_scenes/keese.tscn")
var enemy_stalfos_scene : PackedScene = load("res://scenes/enemy_scenes/stalfos.tscn")
var enemy_gel_scene : PackedScene = load("res://scenes/enemy_scenes/gel.tscn")
var enemy_blade_trap_scene : PackedScene = load("res://scenes/enemy_scenes/blade_trap.tscn")
var enemy_goriya_scene : PackedScene = load("res://scenes/enemy_scenes/goriya.tscn")
var boss_aquamentus_scene : PackedScene = load("res://scenes/enemy_scenes/aquamentus.tscn")
var dropped_item_scene : PackedScene = load("res://scenes/dropped_item.tscn")
var hyrule_music : AudioStreamWAV = load("res://sound/music/02 Overworld BGM.wav")
var dungeon_music : AudioStreamWAV = load("res://sound/music/dungeon_music.wav")

var current_area : Node2D

var link_using_whistle : bool
var is_inside_dungeon : bool

signal left_tile(tile_position : Vector2)
signal entered_tile(tile_position : Vector2)
signal leaving_tile(tile_position : Vector2)
signal call_new_screen(direction : Vector2)

signal player_death
signal player_health_changed(new_current_amount : int)
signal player_max_health_changed(new_max_amount : int)
signal rupees_changed(new_current_amount : int)
signal keys_changed(new_current_amount : int)
signal bombs_changed(new_current_amount : int)
signal max_bombs_changed(new_max_amount : int)
signal pause_menu_opened
signal pause_menu_closed
signal equipment_slot_a_changed(new_item_type : ENUM.ITEM_TYPE)
signal equipment_slot_b_changed(new_item_type : ENUM.ITEM_TYPE)
signal pause_menu_control(given_control : bool)

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if not is_multiplayer_authority(): return
	$Camera2D.make_current()
	load_starting_positions()
	apply_debug_key_item_list()
	get_tree().root.get_viewport().canvas_cull_mask = camera_cull_mask
	player_max_health_changed.emit(player_stats.max_player_health)
	player_health_changed.emit(player_stats.current_player_health)
	rupees_changed.emit(player_stats.current_rupees)
	keys_changed.emit(player_stats.current_keys)
	bombs_changed.emit(player_stats.current_bombs)
	max_bombs_changed.emit(player_stats.max_bombs)
	equipment_slot_a_changed.emit(current_equipped_item_a)
	equipment_slot_b_changed.emit(current_equipped_item_b)
	$INTERIOR_HANDLER.initialize($Camera2D, $Link, self)

func has_multiplayer_authority() -> bool:
	return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

func get_camera() -> PlayerCamera:
	return $Camera2D

func get_sfx_player() -> SFXPlayer:
	return $Camera2D/SFXPlayer

func get_link_controller() -> LinkController:
	return $Link

func get_multiplayer_synchronizer() -> MultiplayerSynchronizer:
	return $MultiplayerSynchronizer

func _on_camera_2d_camera_start_moving(new_area_position : Vector2, old_area_position : Vector2) -> void:
	left_tile.emit(old_area_position)

func _on_camera_2d_camera_moved(new_area_position : Vector2) -> void:
	var tile_area_map : Dictionary[Vector2i, TileArea] = get_tree().get_first_node_in_group("LevelManager").get_tile_area_map()
	if(tile_area_map.has(Vector2i(new_area_position.x, new_area_position.y))):
		var tile_area : TileArea = tile_area_map[Vector2i(new_area_position.x, new_area_position.y)]
		if(tile_area is DungeonTileArea):
			if(tile_area.player_walk_forward_on_enter):
				await $Link.force_player_walk()
	entered_tile.emit(new_area_position)

func has_player_flag(flag : String) -> bool:
	if(player_stats.player_flags.has(flag)):
		return true
	return false

func add_player_flag(flag : String) -> void:
	if(!player_stats.player_flags.has(flag)):
		player_stats.player_flags.append(flag)

func remove_player_flag(flag : String) -> void:
	if(player_stats.player_flags.has(flag)):
		player_stats.player_flags.erase(flag)

func player_took_damage(damage : int) -> void:
	player_lose_health(damage)
	if(player_stats.current_player_health <= 0):
		player_death.emit()
	$RNG_DROPPER.link_was_hit()

func player_gain_heart(amount : int) -> void:
	player_stats.current_player_health += amount
	if(player_stats.current_player_health > player_stats.max_player_health):
		player_stats.current_player_health = player_stats.max_player_health
	player_health_changed.emit(player_stats.current_player_health)

func player_lose_health(amount : int) -> void:
	player_stats.current_player_health -= amount
	if(player_stats.current_player_health < 0):
		player_stats.current_player_health = 0
	player_health_changed.emit(player_stats.current_player_health)

func change_max_hearts(amount : int) -> void:
	player_stats.max_player_health += amount
	if(player_stats.current_player_health > player_stats.max_player_health):
		player_stats.current_player_health = player_stats.max_player_health
	player_max_health_changed.emit(player_stats.max_player_health)

func change_rupees(amount : int) -> void:
	player_stats.current_rupees += amount
	rupees_changed.emit(player_stats.current_rupees)

func change_keys(amount : int) -> void:
	player_stats.current_keys += amount
	keys_changed.emit(player_stats.current_keys)

func change_bombs(amount : int) -> void:
	player_stats.current_bombs += amount
	bombs_changed.emit(player_stats.current_bombs)

func change_max_bombs(amount : int) -> void:
	player_stats.max_bombs += amount
	max_bombs_changed.emit(player_stats.max_bombs)

func player_pickup_key_item(item_type : ENUM.ITEM_TYPE) -> void:
	# TODO dont do this here 
	$Link.pickup_key_item_animation(item_type)
	
	match item_type:
		ENUM.ITEM_TYPE.WOODEN_SWORD:
			add_player_flag("obtained_wooden_sword")
			if(current_equipped_item_a == ENUM.ITEM_TYPE.NULL):
				equip_key_item(item_type, 1)

func equip_key_item(type : ENUM.ITEM_TYPE, slot : int) -> void:
	if(slot == 0):
		# equip to B slot
		equipment_slot_b_changed.emit(type)
		current_equipped_item_b = type
		
	else:
		# equip to A slot
		equipment_slot_a_changed.emit(type)
		current_equipped_item_a = type

func open_pause_menu() -> void:
	if(GameSettings.game_is_paused or link_using_whistle):
		return
	GameSettings.game_is_paused = true
	get_tree().paused = true
	pause_menu_opened.emit()
	await $Camera2D.open_pause_menu()
	pause_menu_control.emit(true)

func close_pause_menu() -> void:
	if(!GameSettings.game_is_paused or link_using_whistle):
		return
	pause_menu_control.emit(false)
	await $Camera2D.close_pause_menu()
	GameSettings.game_is_paused = false
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

func equipped_b_slot_change(new_item_type : ENUM.ITEM_TYPE) -> void:
	current_equipped_item_b = new_item_type

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("pause_game")):
		if($Camera2D.is_currently_moving or $Camera2D.is_currently_moving_pause_menu):
			return
		if(GameSettings.game_is_paused):
			close_pause_menu()
		else:
			open_pause_menu()

func player_start_enter_door(_door : Area2D) -> void:
	$MusicPlayer.stop()

func player_finish_enter_door(door : Area2D) -> void:
	if(door is RoomEntrance):
		is_inside_dungeon = false
		$INTERIOR_HANDLER.handle_interior(door.interior_data)
		$Link.get_player_state().has_room_events = true
		while !$INTERIOR_HANDLER.player_has_input:
			await get_tree().process_frame
		$Link.get_player_state().has_room_events = false
	elif(door is HyruleEntrance):
		is_inside_dungeon = false
		$Link.global_position = door.link_moveto_position
		$Camera2D.set_camera_tile(door.camera_moveto_position)
		$MusicPlayer.stream = hyrule_music
		$MusicPlayer.play(0.0)
	elif(door is DungeonEntrance):
		if(door is DungeonRoomEntrance):
			$DUNGEON_KEY_ROOM.room_entered(door.dungeon_key_room_settings)
		else:
			$Link.get_player_state().ignore_force_tile_walks = true
			door.entrance_used.emit()
		is_inside_dungeon = true
		$Link.global_position = door.link_moveto_position
		$Link.get_sprite().current_direction = Vector2.DOWN
		$Camera2D.set_camera_tile(door.camera_moveto_position)
		if(!($MusicPlayer.stream == dungeon_music and $MusicPlayer.playing)):
			$MusicPlayer.stream = dungeon_music
			$MusicPlayer.play(0.0)

func picked_up_dungeon_compass() -> void:
	player_stats.has_eagle_compass = true

func apply_debug_key_item_list() -> void:
	if(player_stats.has_wooden_sword):
		add_player_flag("obtained_wooden_sword")
	if(player_stats.has_white_sword):
		add_player_flag("obtained_white_sword")
	if(player_stats.has_magical_sword):
		add_player_flag("obtained_magical_sword")
	if(player_stats.has_wooden_shield):
		add_player_flag("obtained_wooden_shield")
	if(player_stats.has_magical_shield):
		add_player_flag("obtained_magical_shield")
	if(player_stats.has_wooden_boomerang):
		add_player_flag("obtained_wooden_boomerang")
	if(player_stats.has_magical_boomerang):
		add_player_flag("obtained_magical_boomerang")
	if(player_stats.has_bomb):
		add_player_flag("obtained_bomb")
	if(player_stats.has_bow):
		add_player_flag("obtained_bow")
	if(player_stats.has_wooden_arrow):
		add_player_flag("obtained_wooden_arrows")
	if(player_stats.has_silver_arrow):
		add_player_flag("obtained_silver_arrows")
	if(player_stats.has_blue_candle):
		add_player_flag("obtained_blue_candle")
	if(player_stats.has_red_candle):
		add_player_flag("obtained_red_candle")
	if(player_stats.has_recorder):
		add_player_flag("obtained_whistle")
	if(player_stats.has_food):
		add_player_flag("obtained_food")
	if(player_stats.has_letter):
		add_player_flag("obtained_letter")
	if(player_stats.has_red_potion):
		add_player_flag("obtained_red_potion")
	if(player_stats.has_blue_potion):
		add_player_flag("obtained_blue_potion")
	if(player_stats.has_magical_rod):
		add_player_flag("obtained_magic_rod")

func set_player_position(global_coordinate : Vector2) -> void:
	link_starting_global_position = global_coordinate
	starting_tile_coordinate = Utils.get_tile_coordinate_from_global_coordinate(global_coordinate)

func load_starting_positions(wait_frame : bool = true) -> void:
	if(wait_frame):
		await get_tree().process_frame
	$Camera2D.set_camera_tile(starting_tile_coordinate)
	$Link.global_position = link_starting_global_position
	$Link.set_look_direction(link_starting_direction)
