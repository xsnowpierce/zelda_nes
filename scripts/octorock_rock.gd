extends Area2D

@export var move_speed : float = 2
var current_forward_vector : Vector2 = Vector2.UP
var camera

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")

func set_forward_vector(direction : Vector2) -> void:
	current_forward_vector = direction

func _physics_process(_delta: float) -> void:
	if(Utils.is_out_of_bounds(position, camera)):
		kill()
	if(GameSettings.camera_is_moving):
		return
	position += current_forward_vector * move_speed

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		return
	kill()
	
func kill() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Player")):
		kill()
