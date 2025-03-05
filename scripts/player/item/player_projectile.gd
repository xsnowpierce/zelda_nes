extends PlayerAttack

class_name PlayerProjectile

var move_direction : Vector2
var camera
var hit_something : bool = false
@export var move_speed : float = 140
@export var hit_effect_wait_time : float = 0.1

func initialize_projectile(camera_object : Camera2D, direction : Vector2) -> void:
	camera = camera_object
	move_direction = direction

func check_screen_bounds() -> void:
	if(Utils.is_out_of_bounds(global_position, camera, false)):
		hit_effect()

func hit_effect() -> void:
	hit_something = true
	$AnimatedSprite2D.play("hit")
	await get_tree().create_timer(hit_effect_wait_time).timeout
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	global_position = area.global_position + Vector2(8, 8)
	hit_effect()
