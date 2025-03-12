extends Entity

class_name InteractableBlock

var link_area : PlayerData
var difference_deadzone : float = 0.5
@export var block_size : Vector2 = Vector2(16, 16)

func _on_area_2d_area_entered(area: Area2D) -> void:
	link_area = area.get_parent().player_data

func _on_area_2d_area_exited(area: Area2D) -> void:
	link_area = null

func update() -> void:
	var required_look_direction = get_required_link_look_direction()

func get_required_link_look_direction() -> Vector2:
	var required_look_direction : Vector2
	var link_position = link_area.get_link_controller().global_position
	if link_position.x > global_position.x + (block_size.x - 1):
		required_look_direction = Vector2.LEFT
	elif link_position.x < global_position.x:
		required_look_direction = Vector2.RIGHT
	elif link_position.y > global_position.y + (block_size.y - 1):
		required_look_direction = Vector2.UP
	else:
		required_look_direction = Vector2.DOWN
	return required_look_direction

func get_difference(one : float, two : float) -> float:
	return abs(one - two)

func block_interact(interacted_from_direction : Vector2) -> void:
	pass
