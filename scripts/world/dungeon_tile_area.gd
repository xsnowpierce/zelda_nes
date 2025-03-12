extends TileArea

class_name DungeonTileArea

@export var player_walk_forward_on_enter : bool = false

@export_group("Starting Door Statuses")
@export var door_north_status : DungeonDoor.DOOR_STATUS
@export var door_south_status : DungeonDoor.DOOR_STATUS
@export var door_east_status : DungeonDoor.DOOR_STATUS
@export var door_west_status : DungeonDoor.DOOR_STATUS

func _ready() -> void:
	super()
	$"Dungeon Walls/Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.NORTH, door_north_status)
	$"Dungeon Walls/Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.SOUTH, door_south_status)
	$"Dungeon Walls/Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.EAST, door_east_status)
	$"Dungeon Walls/Dungeon Tile Doors".set_door_value(DungeonTileDoors.DOOR_DIRECTION.WEST, door_west_status)

func tile_entered() -> void:
	super()
	if(tile_is_loaded):
		return
	$"Dungeon Walls".tile_entered()
	for child in get_children():
		if(child is DungeonTileListener):
			child.awake()
	for child in get_children():
		if(child is DungeonTileListener):
			child.start()
			
func tile_exited() -> void:
	super()
	$"Dungeon Walls".tile_exited()
	for child in get_children():
		if(child is DungeonTileListener):
			child.exit()

func set_link_force_move_areas(value : bool) -> void:
	$"Dungeon Walls".set_force_walk_values(value)

func set_door_value(direction : DungeonTileDoors.DOOR_DIRECTION, door_status : DungeonDoor.DOOR_STATUS) -> void:
	$"Dungeon Walls/Dungeon Tile Doors".set_door_value(direction, door_status)
