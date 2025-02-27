extends AnimatedSprite2D

@export var item_select_positions : Array[Vector2]

func set_selected_item(index : int) -> void:
	position = item_select_positions[index]


func _on_pausemenu_ui_selected_item_change(new_index: int) -> void:
	set_selected_item(new_index)
