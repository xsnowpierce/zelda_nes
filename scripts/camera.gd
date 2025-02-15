extends Camera2D

var is_currently_moving : bool = false
@export var camera_move_speed : float = 180
signal camera_moved(new_area_position : Vector2)

func _ready() -> void:
	await get_tree().process_frame
	camera_moved.emit(Vector2(position.x / GameSettings.map_screen_size.x, position.y / GameSettings.map_screen_size.y))

func _on_link_call_new_screen(direction: Vector2) -> void:
	if(is_currently_moving):
		return
	
	is_currently_moving = true
	GameSettings.camera_is_moving = true
	
	var target_position = position + Vector2(GameSettings.map_screen_size.x * direction.x, GameSettings.map_screen_size.y * direction.y)

	while (position.distance_to(target_position) > 1):
		var move_distance = camera_move_speed * get_process_delta_time()  # Distance to move this frame
		position = position.move_toward(target_position, move_distance)  # Move at constant speed
		await get_tree().process_frame

	# Ensure we reach the exact target position
	position = target_position
	
	is_currently_moving = false
	GameSettings.camera_is_moving = false
	camera_moved.emit(Vector2(position.x / GameSettings.map_screen_size.x, position.y / GameSettings.map_screen_size.y))

func set_camera_position(location : Vector2) -> void:
	position = location
	camera_moved.emit(Vector2(position.x / GameSettings.map_screen_size.x, position.y / GameSettings.map_screen_size.y))
