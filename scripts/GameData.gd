extends Node

@export var player_flags : Array[String]

@export_group("Enemy Scenes")
@export var enemy_tektite_scene : PackedScene
@export var enemy_octorok_scene : PackedScene

@export_group("UI Controllers")
@export var rupees_ui_controller : TextureRect
@export var keys_ui_controller : TextureRect
@export var bombs_ui_controller : TextureRect

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

var current_room : Node2D
var camera : Camera2D
var link : CharacterBody2D

signal player_death
signal player_health_changed(new_current_amount : int)
signal player_max_health_changed(new_max_amount : int)
signal rupees_changed(new_current_amount : int)
signal keys_changed(new_current_amount : int)
signal bombs_changed(new_current_amount : int)
signal max_bombs_changed(new_max_amount : int)

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	link = get_tree().get_first_node_in_group("Player")
	player_max_health_changed.emit(max_player_health)
	player_health_changed.emit(current_player_health)
	rupees_ui_controller.set_text_amount(current_rupees)
	keys_ui_controller.set_text_amount(current_keys)
	bombs_ui_controller.set_text_amount(current_bombs)

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
	rupees_ui_controller.set_text_amount(current_rupees)

func change_keys(amount : int) -> void:
	current_keys += amount
	keys_changed.emit(current_keys)
	keys_ui_controller.set_text_amount(current_rupees)

func change_bombs(amount : int) -> void:
	current_bombs += amount
	bombs_changed.emit(current_bombs)
	bombs_ui_controller.set_text_amount(current_rupees)

func change_max_bombs(amount : int) -> void:
	max_bombs += amount
	max_bombs_changed.emit(max_bombs)

func player_start_enter_door(door : Area2D) -> void:
	$MusicPlayer.stop()

func player_finish_enter_door(door : Area2D) -> void:
	camera.set_camera_position(door.camera_move_to_position)
	link.position = door.link_move_to_position
	if(door.room_data != null):
		link.wait_for_room_events()
		current_room = door.room_data
		while(!current_room.is_loaded):
			await get_tree().process_frame
		link.finish_room_events()
