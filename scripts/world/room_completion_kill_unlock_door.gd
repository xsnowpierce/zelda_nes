extends DungeonTileListener

@export var close_door_behind : bool = true
@export var close_door_behind_direction : DungeonTileDoors.DOOR_DIRECTION
var room_has_been_completed : bool

func awake() -> void:
	if(!room_has_been_completed):
		if(close_door_behind):
			get_parent().set_door_value(close_door_behind_direction, DungeonDoor.DOOR_STATUS.CLOSED)
			get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.DOOR_OPEN)

func room_completion(last_kill_location : Vector2) -> void:
	room_has_been_completed = true
	get_parent().set_door_value(close_door_behind_direction, DungeonDoor.DOOR_STATUS.OPEN)
	get_tree().get_first_node_in_group("SFXPlayer").play_sound(SFXPlayer.SFX.DOOR_OPEN)
	get_parent().player_walk_forward_on_enter = false

func force_room_completion() -> void:
	room_completion(Vector2.ZERO)
