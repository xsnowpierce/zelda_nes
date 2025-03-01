extends DungeonTileListener

@export var door_to_open : DungeonTileDoors.DOOR_DIRECTION
var enemies_killed : bool
var block_pushed : bool

func awake() -> void:
	$"Pushable Block".awake()

func exit() -> void:
	$"Pushable Block".sleep()

func room_completion(last_kill_location : Vector2) -> void:
	enemies_killed = true
	$"Pushable Block".restrict_upwards_push = false
	$"Pushable Block".restrict_leftways_push = false
	$"Pushable Block".restrict_rightways_push = false
	$"Pushable Block".restrict_downwards_push = false

func _on_pushable_block_was_pushed() -> void:
	block_pushed = true
	get_parent().set_door_value(door_to_open, DungeonDoor.DOOR_STATUS.OPEN)
	var sfxplayer : SFXPlayer = get_tree().get_first_node_in_group("SFXPlayer")
	sfxplayer.play_sound(SFXPlayer.SFX.DOOR_OPEN)
	sfxplayer.play_sound(SFXPlayer.SFX.SECRET_DISCOVER)
