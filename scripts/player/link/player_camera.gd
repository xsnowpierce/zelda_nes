extends Camera2D

class_name PlayerCamera

var is_currently_moving : bool = false
var is_currently_moving_pause_menu : bool = false
@export var camera_move_speed : float = 180
signal camera_moved(new_area_position : Vector2)
signal camera_start_moving(new_area_position : Vector2, old_area_position : Vector2)
var player_data : PlayerData

func _ready() -> void:
	player_data = get_parent()
	if(player_data.has_multiplayer_authority()):
		make_current()
	var current_map_position : Vector2 = Vector2(position.x / GameSettings.map_screen_size.x, position.y / GameSettings.map_screen_size.y)
	camera_moved.emit(current_map_position)

func _on_link_call_new_screen(direction: Vector2) -> void:
	if(!player_data.has_multiplayer_authority()):
		return
	if(is_currently_moving):
		return
	
	is_currently_moving = true
	GameSettings.camera_is_moving = true
	var current_map_position : Vector2 = Vector2(position.x / GameSettings.map_screen_size.x, position.y / GameSettings.map_screen_size.y)
	camera_start_moving.emit(Vector2(current_map_position + direction), current_map_position)
	await move_camera_to_position(position + Vector2(GameSettings.map_screen_size.x * direction.x, GameSettings.map_screen_size.y * direction.y))
	
	is_currently_moving = false
	GameSettings.camera_is_moving = false
	var new_grid_position : Vector2 = Vector2(position.x / GameSettings.map_screen_size.x, position.y / GameSettings.map_screen_size.y)
	camera_moved.emit(new_grid_position)

func move_camera_to_position(target_position : Vector2) -> void:
	while (position.distance_to(target_position) > 1):
		var move_distance = camera_move_speed * get_process_delta_time()  # Distance to move this frame
		position = position.move_toward(target_position, move_distance)  # Move at constant speed
		await get_tree().process_frame

	# Ensure we reach the exact target position
	position = target_position

func move_camera_to_tile(tile_coordinate : Vector2) -> void:
	if(!player_data.has_multiplayer_authority()):
		return
	tile_coordinate.x *= 16 * 16
	tile_coordinate.y *= 11 * 16
	await move_camera_to_position(tile_coordinate)

func set_camera_position(location : Vector2) -> void:
	var altered_location : Vector2 = Vector2i(roundi(location.x / GameSettings.map_screen_size.x), roundi(location.y / GameSettings.map_screen_size.y))
	var current_map_position : Vector2 = Vector2(position.x / GameSettings.map_screen_size.x, position.y / GameSettings.map_screen_size.y)
	camera_start_moving.emit(altered_location, current_map_position)
	position = altered_location
	camera_moved.emit(altered_location)

func set_camera_tile(tile_coordinate : Vector2) -> void:
	var modified_coordinate = tile_coordinate
	modified_coordinate.x *= 16 * 16
	modified_coordinate.y *= 11 * 16
	var current_map_position : Vector2 = Vector2(position.x / GameSettings.map_screen_size.x, position.y / GameSettings.map_screen_size.y)
	camera_start_moving.emit(modified_coordinate, current_map_position)
	position = modified_coordinate
	camera_moved.emit(tile_coordinate)

func open_pause_menu() -> void:
	if(!player_data.has_multiplayer_authority()):
		return
	is_currently_moving_pause_menu = true
	await move_camera_to_position(global_position - Vector2(0, GameSettings.map_screen_size.y))
	is_currently_moving_pause_menu = false

func close_pause_menu() -> void:
	if(!player_data.has_multiplayer_authority()):
		return
	is_currently_moving_pause_menu = true
	await move_camera_to_position(global_position + Vector2(0, GameSettings.map_screen_size.y))
	is_currently_moving_pause_menu = false
