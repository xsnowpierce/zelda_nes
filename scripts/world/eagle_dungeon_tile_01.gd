extends DungeonTileArea

@export var random_map_spawns : Array[EnemySpawnGroup]
var enemy_spawner_scene : PackedScene = load("res://scenes/enemy_spawner.tscn")

signal killed_all_enemies(last_kill_location : Vector2)
	
func tile_entered(previous_tile : Vector2) -> void:
	super(previous_tile)
	if(!random_map_spawns.is_empty()):
		var random_spawn : EnemySpawnGroup = random_map_spawns[randi_range(0, random_map_spawns.size() - 1)] 
		spawn_enemies(random_spawn)
	for child in get_children():
		if(child is DungeonTileListener):
			child.awake()
	for child in get_children():
		if(child is DungeonTileListener):
			child.start()
			
func tile_exited(next_tile : Vector2) -> void:
	super(next_tile)
	for child in $"Spawned Enemies".get_children():
		child.queue_free()
	for child in get_children():
		if(child is DungeonTileListener):
			child.exit()

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
		enemy_object.zora_movable_tile_range = enemy.zora_movable_tile_range
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
