extends Entity

class_name InteractableBlock

var link_area : Area2D
var difference_deadzone : float = 0.5
@export var block_size : Vector2 = Vector2(16, 16)

func _on_area_2d_area_entered(area: Area2D) -> void:
	link_area = area

func _on_area_2d_area_exited(area: Area2D) -> void:
	link_area = null

func _process(delta: float) -> void:
	if !is_awake:
		return
	if !is_instance_valid(link_area):
		return

	var link_position = link_area.global_position - (block_size / 2)
	var difference_x : float = get_difference(link_position.x, global_position.x)
	var difference_y : float = get_difference(link_position.y, global_position.y)

	if difference_x > difference_deadzone and difference_y > difference_deadzone:
		return

	var link_look_direction = get_tree().get_first_node_in_group("Player").get_movement_value()
	var required_look_direction = get_required_link_look_direction()
	if link_look_direction == required_look_direction:
		block_interact(-link_look_direction)

func get_required_link_look_direction() -> Vector2:
	var required_look_direction : Vector2
	if link_area.global_position.x > global_position.x + (block_size.x - 1):
		required_look_direction = Vector2.LEFT
	elif link_area.global_position.x < global_position.x:
		required_look_direction = Vector2.RIGHT
	elif link_area.global_position.y > global_position.y + (block_size.y - 1):
		required_look_direction = Vector2.UP
	else:
		required_look_direction = Vector2.DOWN
	return required_look_direction

func get_difference(one : float, two : float) -> float:
	return abs(one - two)

func block_interact(interacted_from_direction : Vector2) -> void:
	pass
