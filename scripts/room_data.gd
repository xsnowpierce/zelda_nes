extends "res://scripts/area_data.gd"

class_name room_data

var camera
var relative_position : Vector2
var is_awake : bool
@export var npc_disappear_time : float = 1

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	camera.connect("camera_moved", Callable(self, "check_camera_position"))
	relative_position = Vector2(roundi(position.x / GameSettings.map_screen_size.x), roundi(position.y / GameSettings.map_screen_size.y))

func check_camera_position(new_camera_position : Vector2) -> void:
	if(new_camera_position == relative_position):
		awake()
	else:
		sleep()

func awake() -> void:
	is_awake = true
	is_loaded = true

func sleep() -> void:
	is_awake = false
	is_loaded = false

func get_area_type() -> String:
	return "room_data"
