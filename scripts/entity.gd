extends Node2D

var residing_in_area : Vector2
var is_awake : bool
var camera : Camera2D

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	camera.connect("camera_moved", Callable(self, "on_camera_move"))
	residing_in_area = Vector2(roundi(position.x / GameSettings.map_screen_size.x), roundi(position.y / GameSettings.map_screen_size.y))
	
func on_camera_move(area_entered : Vector2) -> void:
	if(area_entered == residing_in_area):
		awake()
	else:
		if(is_awake):
			sleep()
			
func awake():
	is_awake = true
	
func sleep():
	is_awake = false
