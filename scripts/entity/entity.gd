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
	process_while_awake()
	physics_while_awake()

func sleep():
	is_awake = false

func process_while_awake() -> void:
	while is_awake:
		update()
		await get_tree().process_frame

func physics_while_awake() -> void:
	while is_awake:
		physics_update()
		await get_tree().physics_frame

func update() -> void:
	pass

func physics_update() -> void:
	pass
