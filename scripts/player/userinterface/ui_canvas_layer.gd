extends CanvasLayer

@export var camera_position_offset : Vector2
var camera

func _ready() -> void:
	if(get_parent().has_multiplayer_authority()):
		visible = true
	else:
		hide()
	camera = get_parent().get_camera()
	$"Control/pausemenu UI".has_bow = get_parent().player_stats.has_bow

func _on_game_pause_menu_opened() -> void:
	follow_viewport_enabled = true
	offset = camera.position + camera_position_offset
	$"Control/pausemenu UI".has_bow = get_parent().player_stats.has_bow

func _on_game_pause_menu_closed() -> void:
	await get_tree().process_frame
	while camera.is_currently_moving or camera.is_currently_moving_pause_menu:
		await get_tree().process_frame
	follow_viewport_enabled = false
	offset = Vector2.ZERO
