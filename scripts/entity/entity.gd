extends Node2D

class_name Entity

var residing_in_area : Vector2
var is_awake : bool
var camera : Camera2D

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")
	residing_in_area = Vector2(roundi(position.x / GameSettings.map_screen_size.x), roundi(position.y / GameSettings.map_screen_size.y))
			
func awake():
	is_awake = true
	
func sleep():
	is_awake = false
