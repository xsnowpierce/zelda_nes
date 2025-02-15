extends Node2D

var camera
var is_loaded : bool
var relative_position : Vector2
var is_awake : bool

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	camera.connect("camera_moved", Callable(self, "check_camera_position"))
	relative_position = Vector2(position.x / GameSettings.map_screen_size.x, position.y / GameSettings.map_screen_size.y)

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
