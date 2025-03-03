extends DungeonTileArea

var key_item_prefab : PackedScene = load("res://scenes/key_item.tscn")
var key_item_object : Node2D

func _ready() -> void:
	tile_area_position = Vector2(global_position.x / 16 / 16, global_position.y / 16 / 11)

func room_entered(room_settings : DungeonKeyRoomSettings) -> void:
	if(!room_settings.random_map_spawns.is_empty()):
		var random_spawn : EnemySpawnGroup = room_settings.random_map_spawns[randi_range(0, room_settings.random_map_spawns.size() - 1)] 
		spawn_enemies(random_spawn)
	$DUNGEON_ENTRANCE.link_moveto_position = room_settings.leave_room_teleport_position
	$DUNGEON_ENTRANCE.camera_moveto_position = room_settings.leave_camera_grid_teleport_position
	spawn_key_item(room_settings.key_item_held, room_settings.key_item_spawn_position)

func spawn_key_item(key_item : ENUM.KEY_ITEM_TYPE, spawn_position : Vector2) -> void:
	key_item_object = key_item_prefab.instantiate()
	add_child(key_item_object)
	key_item_object.set_item_value(key_item)
	key_item_object.global_position = global_position + (spawn_position * 16)

func room_exited() -> void:
	for child in $"Spawned Enemies".get_children():
		child.queue_free()
	if(is_instance_valid(key_item_object)):
		key_item_object.queue_free()
