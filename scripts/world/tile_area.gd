extends Node2D

class_name TileArea

var tile_area_position : Vector2
var tile_is_loaded : bool = false

signal killed_all_enemies(last_kill_location : Vector2)

@export var random_map_spawns : Array[EnemySpawnGroup]
var enemy_spawner_scene : PackedScene = load("res://scenes/enemy_spawner.tscn")

func _ready() -> void:
	tile_area_position = Vector2(global_position.x / 16 / 16, global_position.y / 16 / 11)

func tile_entered(previous_tile : Vector2) -> void:
	tile_is_loaded = true
	if(get_node("Entities") != null):
		for entity in $Entities.get_children():
			entity.awake()
	if(!random_map_spawns.is_empty()):
		var random_spawn : EnemySpawnGroup = random_map_spawns[randi_range(0, random_map_spawns.size() - 1)] 
		spawn_enemies(random_spawn)

func tile_exited(next_tile : Vector2) -> void:
	tile_is_loaded = false
	if(get_node("Entities") != null):
		for entity in $Entities.get_children():
			entity.sleep()
	if(get_node("Spawned Enemies") != null):
		for child in $"Spawned Enemies".get_children():
			child.queue_free()

func spawn_enemies(enemies : EnemySpawnGroup) -> void:
	var spawns : int = 0
	for enemy in enemies.enemy_spawns:
		if(enemy == null):
			continue
		if(enemy.has_been_killed):
			continue
		var enemy_object = enemy_spawner_scene.instantiate()
		enemy_object.spawn_object_parent = $"Spawned Enemies"
		if(enemies.hide_spawn_clouds):
			enemy_object.override_cloud_visibility = true
			enemy_object.overriden_cloud_visibiity = false
		enemy_object.enemy_spawn_delay = enemy.spawn_delay
		enemy_object.enemy_type = enemy.enemy_type
		$"Spawned Enemies".add_child(enemy_object)
		var spawn_position : Vector2 = Vector2.ZERO
		match enemy.use_spawn_type:
			EnemySpawn.USE_SPAWN_TYPE.GLOBAL_POSITION:
				spawn_position = enemy.global_spawn_position
			EnemySpawn.USE_SPAWN_TYPE.RELATIVE_GRID:
				spawn_position = global_position + (enemy.relative_grid_position * 16)
		enemy_object.global_position = spawn_position
		enemy_object.connect("enemy_killed", Callable(self, "enemy_has_been_killed"))
		enemy_object.spawner_id = spawns
		enemy_object.zora_movable_tile_range = enemy.zora_movable_tile_range
		enemy_object.blade_trap_settings = enemy.blade_trap_settings
		enemy_object.stalfos_spawn_with_key = enemy.spawn_with_key
		spawns += 1
		enemy_object.awake()

func enemy_has_been_killed(enemy_spawner : EnemySpawner, location : Vector2) -> void:
	for spawn_group in random_map_spawns:
		spawn_group.enemy_spawns[enemy_spawner.spawner_id] = null
	enemy_spawner.queue_free()
	if(check_for_all_dead()):
		killed_all_enemies.emit(location)

func check_for_all_dead() -> bool:
	for spawn_group in random_map_spawns:
		for enemy in spawn_group.enemy_spawns:
			if(is_instance_valid(enemy)):
				return false
	return true

func get_entities() -> Node:
	return $Entities
