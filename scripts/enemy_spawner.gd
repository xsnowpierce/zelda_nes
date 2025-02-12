extends Node2D

var residing_in_area : Vector2
var is_awake : bool
@export var enemy_type : ENUM.ENEMY_TYPE
var enemy_scene

func _ready() -> void:
	var camera := get_tree().get_first_node_in_group("Camera")
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
	$Sprite2D.play()
	
func sleep():
	is_awake = false
	if(is_instance_valid(enemy_scene)):
		enemy_scene.queue_free()
	$Sprite2D.frame = 0
	$Sprite2D.visible = true

func _on_sprite_2d_animation_looped() -> void:
	if(enemy_scene == null):
		$Sprite2D.visible = false
		match enemy_type:
			ENUM.ENEMY_TYPE.TEKTITE:
				enemy_scene = get_parent().enemy_tektite_scene.instantiate()
			ENUM.ENEMY_TYPE.OCTOROK:
				enemy_scene = get_parent().enemy_octorok_scene.instantiate()
		
		enemy_scene.position = position
		get_parent().add_child(enemy_scene)
		enemy_scene.connect("has_died", Callable(self, "spawned_enemy_has_died"))
		$Sprite2D.stop()

func spawned_enemy_has_died() -> void:
	queue_free()
