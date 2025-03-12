extends Node2D

var camera : Camera2D

func initialize_food(camera_object : Camera2D) -> void:
	camera = camera_object

func _process(delta: float) -> void:
	if((GameSettings.camera_is_moving or Utils.is_out_of_bounds(global_position, camera, false)) and !GameSettings.game_is_paused):
		queue_free()
