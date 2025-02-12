extends Area2D

@export var move_speed : float = 2
var current_forward_vector : Vector2 = Vector2.UP

func set_forward_vector(direction : Vector2) -> void:
	current_forward_vector = direction

func _physics_process(delta: float) -> void:
	if(check_if_out_of_bounds()):
		kill()
	if(GameSettings.camera_is_moving):
		return
	position += current_forward_vector * move_speed

func check_if_out_of_bounds() -> bool:
	var camera = get_tree().get_first_node_in_group("Camera")
	var relative_position = position - camera.position
	if(relative_position.x <= GameSettings.screen_boundaries.x):
		return true
	elif(relative_position.x >= GameSettings.screen_boundaries.y - 16):
		return true
	if(relative_position.y <= GameSettings.screen_boundaries.z):
		return true
	elif(relative_position.y >= GameSettings.screen_boundaries.w - 16):
		return true
	
	return false

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		return
	kill()
	
func kill() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Player")):
		kill()
