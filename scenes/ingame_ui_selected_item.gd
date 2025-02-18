extends "res://scripts/ui_selected_item.gd"

func _on_game_pause_menu_opened() -> void:
	$TextureRect.visible = false
	
func _on_game_pause_menu_closed() -> void:
	$TextureRect.visible = true
