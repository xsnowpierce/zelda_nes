extends PlayerProjectile

class_name ArrowProjectile

func initialize_arrow(direction : Vector2, camera_object : Camera2D) -> void:
	super.initialize_projectile(camera_object, direction)
	match direction:
		Vector2.RIGHT:
			$AnimatedSprite2D.play("right")
		Vector2.LEFT:
			$AnimatedSprite2D.play("left")
		Vector2.UP:
			$AnimatedSprite2D.play("up")
		Vector2.DOWN:
			$AnimatedSprite2D.play("down")
	
func _process(delta: float) -> void:
	check_screen_bounds()
	if(!hit_something):
		global_position += move_direction * move_speed * get_process_delta_time()
