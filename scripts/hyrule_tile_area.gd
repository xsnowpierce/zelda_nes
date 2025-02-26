extends "res://scripts/tile_area.gd"

@export var random_map_spawns : Array[EnemySpawnGroup]

var enemy_spawner_scene : PackedScene = load("res://scenes/enemy_spawner.tscn")

func _ready() -> void:
	super()

func tile_entered(previous_tile : Vector2) -> void:
	if(!random_map_spawns.is_empty()):
		var random_spawn : EnemySpawnGroup = random_map_spawns[randi_range(0, random_map_spawns.size() - 1)] 
		spawn_enemies(random_spawn)
	for entity in $Entities.get_children():
		entity.awake()

func tile_exited(next_tile : Vector2) -> void:
	for child in $"Spawned Enemies".get_children():
		child.queue_free()
	for entity in $Entities.get_children():
		entity.sleep()
	
func spawn_enemies(enemies : EnemySpawnGroup) -> void:
	var spawns : int = 0
	for enemy in enemies.enemy_spawns:
		if(enemy == null):
			continue
		if(enemy.has_been_killed):
			continue
		var enemy_object = enemy_spawner_scene.instantiate()
		enemy_object.enemy_type = enemy.enemy_type
		$"Spawned Enemies".add_child(enemy_object)
		enemy_object.global_position = enemy.global_spawn_position
		enemy_object.connect("enemy_killed", Callable(self, "enemy_has_been_killed"))
		enemy_object.spawner_id = spawns
		if(enemy.enemy_type == ENUM.ENEMY_TYPE.ZORA):
			enemy_object.zora_movable_tile_range = enemy.zora_movable_tile_range
		spawns += 1
		enemy_object.awake()

func enemy_has_been_killed(enemy_spawner : EnemySpawner) -> void:
	for spawn_group in random_map_spawns:
		spawn_group.enemy_spawns[enemy_spawner.spawner_id] = null
	enemy_spawner.queue_free()
