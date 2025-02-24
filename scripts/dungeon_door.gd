extends Node2D

class_name DungeonDoor

const OPEN_DOOR_FRAME : int = 0
const LOCKED_DOOR_FRAME : int = 1
const CLOSED_DOOR_FRAME : int = 2
const WALL_DOOR_FRAME : int = 3
const EXPLODED_DOOR_FRAME: int = 4

enum DOOR_STATUS { OPEN, LOCKED, CLOSED, WALL, HOLE }

func set_door_status(door_status : DOOR_STATUS) -> void:
	match door_status:
		DOOR_STATUS.OPEN:
			$"Door Sprite".frame = OPEN_DOOR_FRAME
			$"Doorway Collider/CollisionShape2D".set_disabled(true)
		DOOR_STATUS.LOCKED:
			$"Door Sprite".frame = LOCKED_DOOR_FRAME
			$"Doorway Collider/CollisionShape2D".set_disabled(false)
		DOOR_STATUS.CLOSED:
			$"Door Sprite".frame = CLOSED_DOOR_FRAME
			$"Doorway Collider/CollisionShape2D".set_disabled(false)
		DOOR_STATUS.WALL:
			$"Door Sprite".frame = WALL_DOOR_FRAME
			$"Doorway Collider/CollisionShape2D".set_disabled(false)
		DOOR_STATUS.HOLE:
			$"Door Sprite".frame = EXPLODED_DOOR_FRAME
			$"Doorway Collider/CollisionShape2D".set_disabled(true)
