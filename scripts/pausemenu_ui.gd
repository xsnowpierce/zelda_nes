extends ColorRect

func open_pause_menu() -> void:
	pass

func close_pause_menu() -> void:
	pass

func _on_game_pause_menu_opened() -> void:
	open_pause_menu()
	get_parent().follow_viewport_enabled = false

func _on_game_pause_menu_closed() -> void:
	close_pause_menu()
	get_parent().follow_viewport_enabled = true
