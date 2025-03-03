extends Entity

class_name EnemySpawner

var game_data : GameData
var enemy_type : ENUM.ENEMY_TYPE
var enemy_scene
var should_cloud_be_visible : bool
var zora_movable_tile_range : Array[Vector4]
var stalfos_spawn_with_key : bool
var spawner_id : int
signal enemy_killed(spawner : EnemySpawner, location : Vector2)
var dropped_item_scene : PackedScene = load("res://scenes/dropped_item.tscn")
var key_scene : Node2D
var blade_trap_settings : BladeTrapSettings

func _ready() -> void:
	super()
	$Sprite2D.visible = false
	set_cloud_visibility()
	game_data = get_tree().get_first_node_in_group("GameData")

func set_cloud_visibility() -> void:
	match enemy_type:
			ENUM.ENEMY_TYPE.ZORA:
				should_cloud_be_visible = false
			ENUM.ENEMY_TYPE.LEEVER:
				should_cloud_be_visible = false
			ENUM.ENEMY_TYPE.PEAHAT:
				should_cloud_be_visible = false
			_:
				should_cloud_be_visible = true

func awake():
	super()
	if(stalfos_spawn_with_key):
		key_scene = dropped_item_scene.instantiate()
		add_child(key_scene)
		key_scene.set_item_type(ENUM.ITEM_TYPE.KEY)
		key_scene.global_position = global_position
	if(should_cloud_be_visible):
		$Sprite2D.visible = true
		$Sprite2D.play()
	else:
		_on_sprite_2d_animation_looped()
	
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
			ENUM.ENEMY_TYPE.BLUE_TEKTITE:
				enemy_scene = game_data.enemy_blue_tektite_scene.instantiate()
			ENUM.ENEMY_TYPE.PEAHAT:
				enemy_scene = game_data.enemy_peahat_scene.instantiate()
			ENUM.ENEMY_TYPE.KEESE:
				enemy_scene = game_data.enemy_keese_scene.instantiate()
			ENUM.ENEMY_TYPE.STALFOS:
				enemy_scene = game_data.enemy_stalfos_scene.instantiate()
			ENUM.ENEMY_TYPE.GEL:
				enemy_scene = game_data.enemy_gel_scene.instantiate()
			ENUM.ENEMY_TYPE.BLADE_TRAP:
				enemy_scene = game_data.enemy_blade_trap_scene.instantiate()
				enemy_scene.load_blade_trap_settings(blade_trap_settings)
			ENUM.ENEMY_TYPE.GORIYA:
				enemy_scene = game_data.enemy_goriya_scene.instantiate()
			_:
				printerr("Tried to spawn enemy that does not have a set scene in GameData. (", str(enemy_type), ", ", ENUM.ENEMY_TYPE.keys()[enemy_type] ,")")
				$Sprite2D.stop()
				return
				
		get_parent().add_child(enemy_scene)
		enemy_scene.enemy_type = enemy_type
		if(is_instance_valid(key_scene)):
			remove_child(key_scene)
			enemy_scene.add_child(key_scene)
		enemy_scene.connect("has_died", Callable(self, "spawned_enemy_has_died"))
		enemy_scene.global_position = global_position
		$Sprite2D.stop()

func spawned_enemy_has_died() -> void:
	var killed_location : Vector2 = enemy_scene.global_position
	enemy_killed.emit(self, killed_location)
