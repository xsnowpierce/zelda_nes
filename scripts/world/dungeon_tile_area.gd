extends TileArea

class_name DungeonTileArea

@export var random_map_spawns : Array[EnemySpawnGroup]
var enemy_spawner_scene : PackedScene = load("res://scenes/enemy_spawner.tscn")

signal killed_all_enemies(last_kill_location : Vector2)

@export_group("Starting Door Statuses")
@export var door_north_status : DungeonDoor.DOOR_STATUS
@export var door_south_status : DungeonDoor.DOOR_STATUS
@export var door_east_status : DungeonDoor.DOOR_STATUS
@export var door_west_status : DungeonDoor.DOOR_STATUS

func _ready() -> void:
	super()
	if(get_node("Entities") != null):
		for entity in $Entities.get_children():
			entity.sleep()
	$"Dungeon Walls/Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.NORTH, door_north_status)
	$"Dungeon Walls/Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.SOUTH, door_south_status)
	$"Dungeon Walls/Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.EAST, door_east_status)
	$"Dungeon Walls/Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.WEST, door_west_status)

func tile_entered(previous_tile : Vector2) -> void:
	if(tile_is_loaded):
		return
	super(previous_tile)
	if(get_node("Entities") != null):
		for entity in $Entities.get_children():
			entity.awake()
	$"Dungeon Walls".tile_entered(previous_tile)
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
	$"Dungeon Walls".tile_exited(next_tile)
	for child in $"Spawned Enemies".get_children():
		child.queue_free()
	for child in get_children():
		if(child is DungeonTileListener):
			child.exit()
	if(get_node("Entities") != null):
		for entity in $Entities.get_children():
			entity.sleep()

func set_link_force_move_areas(value : bool) -> void:
	$"Dungeon Walls".set_force_walk_values(value)

func set_door_value(direction : DungeonTileDoors.DOOR_DIRECTION, door_status : DungeonDoor.DOOR_STATUS) -> void:
	$"Dungeon Walls/Dungeon Tile Doors".set_door_value(direction, door_status)

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
		enemy_object.stalfos_spawn_with_key = enemy.spawn_with_key
		enemy_object.blade_trap_settings = enemy.blade_trap_settings
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
