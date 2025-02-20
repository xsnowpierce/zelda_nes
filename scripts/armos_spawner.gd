extends Node2D

var residing_in_area : Vector2
var is_awake : bool
var game_data : Node
var armos_scene : PackedScene = load("res://scenes/armos.tscn")
var spawned_armos
var has_spawned : bool
var link
@export var disappear_timer : float = 1 

func _ready() -> void:
	var camera := get_tree().get_first_node_in_group("Camera")
	game_data = get_tree().get_first_node_in_group("GameData")
	camera.connect("camera_moved", Callable(self, "on_camera_move"))
	residing_in_area = Vector2(roundi(position.x / GameSettings.map_screen_size.x), roundi(position.y / GameSettings.map_screen_size.y))

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(has_spawned):
		return
	
	
		
	has_spawned = true
	spawned_armos = armos_scene.instantiate()
	get_parent().call_deferred("add_child", spawned_armos)
	spawned_armos.global_position = global_position
	spawned_armos.connect("has_died", Callable(self, "spawned_enemy_has_died"))
	await get_tree().create_timer(disappear_timer).timeout
	$StaticBody2D/CollisionShape2D.call_deferred("set_disabled", true)
	$Area2D/CollisionShape2D.call_deferred("set_disabled", true)
	$Sprite2D.visible = false
	
func on_camera_move(area_entered : Vector2) -> void:
	if(area_entered == residing_in_area):
		awake()
	else:
		if(is_awake):
			sleep()

func awake():
	link = get_tree().get_first_node_in_group("Player")
	is_awake = true
	$StaticBody2D/CollisionShape2D.disabled = false
	$Area2D/CollisionShape2D.disabled = false
	$Sprite2D.visible = true
	
func sleep():
	is_awake = false
	has_spawned = false
	if(is_instance_valid(spawned_armos)):
		spawned_armos.queue_free()
		
func spawned_enemy_has_died() -> void:
	queue_free()
