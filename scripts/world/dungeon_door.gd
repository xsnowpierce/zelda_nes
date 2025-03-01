extends InteractableBlock

class_name DungeonDoor

@export var unlock_wait_time : float = 0.3
var interacting : bool

const OPEN_DOOR_FRAME : int = 0
const LOCKED_DOOR_FRAME : int = 1
const CLOSED_DOOR_FRAME : int = 2
const WALL_DOOR_FRAME : int = 3
const EXPLODED_DOOR_FRAME: int = 4

enum DOOR_STATUS { OPEN, LOCKED, CLOSED, WALL, HOLE }

var current_door_status : DOOR_STATUS
signal door_unlock

func set_door_status(door_status : DOOR_STATUS) -> void:
	match door_status:
		DOOR_STATUS.OPEN:
			$"Door Sprite".frame = OPEN_DOOR_FRAME
			$"Doorway Collider/CollisionShape2D".call_deferred("set_disabled", true)
			current_door_status = DOOR_STATUS.OPEN
		DOOR_STATUS.LOCKED:
			$"Door Sprite".frame = LOCKED_DOOR_FRAME
			$"Doorway Collider/CollisionShape2D".call_deferred("set_disabled", false)
			current_door_status = DOOR_STATUS.LOCKED
		DOOR_STATUS.CLOSED:
			$"Door Sprite".frame = CLOSED_DOOR_FRAME
			$"Doorway Collider/CollisionShape2D".call_deferred("set_disabled", false)
			current_door_status = DOOR_STATUS.CLOSED
		DOOR_STATUS.WALL:
			$"Door Sprite".frame = WALL_DOOR_FRAME
			$"Doorway Collider/CollisionShape2D".call_deferred("set_disabled", false)
			current_door_status = DOOR_STATUS.WALL
		DOOR_STATUS.HOLE:
			$"Door Sprite".frame = EXPLODED_DOOR_FRAME
			$"Doorway Collider/CollisionShape2D".call_deferred("set_disabled", true)
			current_door_status = DOOR_STATUS.HOLE

func block_interact(interacted_from_direction : Vector2) -> void:
	if(current_door_status == DOOR_STATUS.LOCKED):
		if(interacting):
			return
		interacting = true
		var game_data : GameData = get_tree().get_first_node_in_group("GameData")
		if(game_data.current_keys > 0):
			get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.DOOR_OPEN)
			await get_tree().create_timer(unlock_wait_time).timeout
			game_data.change_keys(-1)
			door_unlock.emit()
			set_door_status(DOOR_STATUS.OPEN)
