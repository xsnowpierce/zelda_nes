extends CanvasLayer

@export var camera_position_offset : Vector2
var camera

func _ready() -> void:
	visible = true
	camera = get_tree().get_first_node_in_group("Camera")

func _on_game_pause_menu_opened() -> void:
	follow_viewport_enabled = true
	offset = camera.position + camera_position_offset

func _on_game_pause_menu_closed() -> void:
	await get_tree().process_frame
	while camera.is_currently_moving or camera.is_currently_moving_pause_menu:
		await get_tree().process_frame
	follow_viewport_enabled = false
	offset = Vector2.ZERO
