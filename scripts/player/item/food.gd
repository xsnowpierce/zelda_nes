extends Node2D

var camera : Camera2D
var game_data : GameData

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	game_data = get_tree().get_first_node_in_group("GameData")

func _process(delta: float) -> void:
	if((GameSettings.camera_is_moving or Utils.is_out_of_bounds(global_position, camera, false)) and !game_data.game_is_paused):
		queue_free()
