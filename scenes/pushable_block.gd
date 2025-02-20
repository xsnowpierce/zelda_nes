extends "res://scenes/interactable_block.gd"

var starting_position : Vector2
@export var move_speed : float = 25
var is_moving : bool
@export var move_times : int = -1
signal was_pushed

func _ready() -> void:
	super()
	starting_position = global_position

func block_interact(interacted_from_direction : Vector2) -> void:
	if(is_moving or move_times == 0):
		return
	is_moving = true
	var target_position = global_position + (-interacted_from_direction * 16)
	if(!is_target_position_in_bounds(target_position)):
		return
	# move to position
	while (position.distance_to(target_position) > 1):
		if(!can_move()):
			break
		var move_distance = move_speed * get_process_delta_time()  # Distance to move this frame
		global_position = global_position.move_toward(target_position, move_distance)  # Move at constant speed
		await get_tree().process_frame
	global_position = target_position
	move_times -= 1
	is_moving = false
	was_pushed.emit()

func is_target_position_in_bounds(target_position : Vector2) -> bool:
	if(Utils.is_out_of_bounds(target_position, camera)):
		return false
	return true

func can_move() -> bool:
	if(GameSettings.camera_is_moving or !is_awake):
		return false
	return true

func sleep() -> void:
	super()
	global_position = starting_position
