extends Node

@export var spawn_key_location : Vector2
@export var drop_at_last_enemy_killed : bool
var dropped_item_scene : PackedScene = load("res://scenes/dropped_item.tscn")

func room_completion(last_kill_location : Vector2) -> void:
	var key_object : Node2D = dropped_item_scene.instantiate()
	add_child(key_object)
	if(drop_at_last_enemy_killed):
		key_object.global_position = last_kill_location
	else:
		key_object.global_position = spawn_key_location
	key_object.set_item_type(ENUM.ITEM_TYPE.KEY)
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.KEY_APPEARANCE)
