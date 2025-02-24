extends Node2D

class_name DungeonTileDoors

enum DOOR_DIRECTION { NORTH, SOUTH, EAST, WEST }

func set_door_value(direction : DOOR_DIRECTION, door_status : DungeonDoor.DOOR_STATUS) -> void:
	match direction:
		DOOR_DIRECTION.NORTH:
			$"North Door".set_door_status(door_status)
		DOOR_DIRECTION.SOUTH:
			$"South Door".set_door_status(door_status)
		DOOR_DIRECTION.EAST:
			$"East Door".set_door_status(door_status)
		DOOR_DIRECTION.WEST:
			$"West Door".set_door_status(door_status)

func set_room_active(value : bool) -> void:
	pass
