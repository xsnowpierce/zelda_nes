extends Node

class_name GameManager

@export var level_manager : LevelManager
const Player = preload("res://scenes/player.tscn")

func add_player(peer_id) -> void:
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child.call_deferred(player)
	player.set_multiplayer_authority(peer_id)
	player.connect("entered_tile", Callable(level_manager, "player_entered_tile"))
	player.connect("left_tile", Callable(level_manager, "player_left_tile"))
	player.call_deferred("set_player_position", $SPAWNPOINT.global_position)
