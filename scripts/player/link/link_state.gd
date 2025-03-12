extends Node

class_name LinkState

var player : LinkController

var is_pickup_animation : bool
var is_position_correcting : bool
var is_attacking : bool
var is_attacked_knockback : bool
var is_entering_door : bool = false
var is_exiting_door : bool = false
var has_room_events : bool = false
var is_inside_room : bool
var is_placing_item : bool
var is_shooting_magical_wand : bool
var is_entering_new_tile : bool
var ignore_force_tile_walks : bool

func initialize(parent : LinkController) -> void:
	player = parent

func is_player_input_allowed() -> bool:
	return (!GameSettings.camera_is_moving 
		and !is_entering_door 
		and !is_exiting_door 
		and !has_room_events 
		and !is_pickup_animation
		and !GameSettings.game_is_paused
		and !is_attacked_knockback
		and !is_placing_item
		and !is_shooting_magical_wand
		and !is_entering_new_tile)
