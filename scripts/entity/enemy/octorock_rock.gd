extends Area2D

class_name EnemyProjectile

@export var move_speed : float = 2
@export var attack_contact_damage : int = 1
var current_forward_vector : Vector2 = Vector2.UP
var camera
@export var attack_block_level : ENUM.BLOCK_ATTACK_LEVEL

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")

func set_forward_vector(direction : Vector2) -> void:
	current_forward_vector = direction

func _physics_process(_delta: float) -> void:
	if(Utils.is_out_of_bounds(global_position, camera, true)):
		kill()
	if(GameSettings.camera_is_moving):
		return
	global_position += current_forward_vector * move_speed

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		return
	kill()
	
func kill() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Player")):
		await get_tree().process_frame
		kill()
