extends TileArea

@export_group("Starting Door Statuses")
@export var door_north_status : DungeonDoor.DOOR_STATUS
@export var door_south_status : DungeonDoor.DOOR_STATUS
@export var door_east_status : DungeonDoor.DOOR_STATUS
@export var door_west_status : DungeonDoor.DOOR_STATUS

func _ready() -> void:
	$"Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.NORTH, door_north_status)
	$"Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.SOUTH, door_south_status)
	$"Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.EAST, door_east_status)
	$"Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.WEST, door_west_status)

func tile_entered(previous_tile : Vector2) -> void:
	$"Dungeon Tile Doors".set_room_active(true)

func tile_exited(next_tile : Vector2) -> void:
	$"Dungeon Tile Doors".set_room_active(false)
