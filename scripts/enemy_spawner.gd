extends "res://scripts/entity.gd"

var game_data : Node
@export var enemy_type : ENUM.ENEMY_TYPE
var enemy_scene
var should_cloud_be_visible : bool
@export_group("Zora Settings")
@export var zora_movable_tile_range : Array[Vector4]


func _ready() -> void:
	$Sprite2D.visible = false
	set_cloud_visibility()
	game_data = get_tree().get_first_node_in_group("GameData")

func set_cloud_visibility() -> void:
	match enemy_type:
			ENUM.ENEMY_TYPE.TEKTITE:
				should_cloud_be_visible = true
			ENUM.ENEMY_TYPE.OCTOROK:
				should_cloud_be_visible = true
			ENUM.ENEMY_TYPE.ZORA:
				should_cloud_be_visible = false
			ENUM.ENEMY_TYPE.LEEVER:
				should_cloud_be_visible = false

func awake():
	super()
	$Sprite2D.visible = should_cloud_be_visible
	$Sprite2D.play()
	
func sleep():
	super()
	if(is_instance_valid(enemy_scene)):
		enemy_scene.queue_free()
	$Sprite2D.frame = 0
	$Sprite2D.visible = should_cloud_be_visible

func _on_sprite_2d_animation_looped() -> void:
	if(enemy_scene == null):
		$Sprite2D.visible = false
		match enemy_type:
			ENUM.ENEMY_TYPE.TEKTITE:
				enemy_scene = game_data.enemy_tektite_scene.instantiate()
			ENUM.ENEMY_TYPE.OCTOROK:
				enemy_scene = game_data.enemy_octorok_scene.instantiate()
			ENUM.ENEMY_TYPE.ZORA:
				enemy_scene = game_data.enemy_zora_scene.instantiate()
				enemy_scene.movable_tile_range = zora_movable_tile_range
			ENUM.ENEMY_TYPE.LEEVER:
				enemy_scene = game_data.enemy_leever_scene.instantiate()
		
		enemy_scene.position = position
		enemy_scene.enemy_type = enemy_type
		game_data.enemy_spawn_parent.add_child(enemy_scene)
		enemy_scene.connect("has_died", Callable(self, "spawned_enemy_has_died"))
		$Sprite2D.stop()

func spawned_enemy_has_died() -> void:
	queue_free()
