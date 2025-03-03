extends Resource

class_name DungeonKeyRoomSettings

@export var random_map_spawns : Array[EnemySpawnGroup]
@export var key_item_held : ENUM.KEY_ITEM_TYPE
@export var key_item_spawn_position : Vector2 = Vector2(0, -1)
@export var leave_room_teleport_position : Vector2
@export var leave_camera_grid_teleport_position : Vector2
