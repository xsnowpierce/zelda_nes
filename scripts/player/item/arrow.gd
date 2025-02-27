extends Node2D

var move_direction : Vector2
var camera
@export var move_speed : float = 140
@export var hit_effect_wait_time : float = 0.1
var hit_something : bool = false

func initialize_arrow(direction : Vector2, camera_object : Camera2D) -> void:
	camera = camera_object
	match direction:
		Vector2.RIGHT:
			$AnimatedSprite2D.play("right")
		Vector2.LEFT:
			$AnimatedSprite2D.play("left")
		Vector2.UP:
			$AnimatedSprite2D.play("up")
		Vector2.DOWN:
			$AnimatedSprite2D.play("down")
	move_direction = direction
	
func _process(delta: float) -> void:
	check_screen_bounds()
	if(!hit_something):
		global_position += move_direction * move_speed * get_process_delta_time()

func check_screen_bounds() -> void:
	if(Utils.is_out_of_bounds(global_position, camera, false)):
		hit_effect()

func hit_effect() -> void:
	hit_something = true
	$AnimatedSprite2D.play("hit")
	await get_tree().create_timer(hit_effect_wait_time).timeout
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	global_position = area.global_position + Vector2(8, 8)
	hit_effect()
