extends AnimatedSprite2D

enum CURRENT_DIRECTION { LEFT, RIGHT, UP, DOWN }
var current_direction : CURRENT_DIRECTION
var is_attacking : bool = false
signal attack_ended

func _on_character_body_2d_move_velocity(velocity: Vector2) -> void:
	var anim_name : String
	if(is_attacking):
		anim_name = "attack_wooden_"
	if(velocity.normalized() == Vector2.LEFT):
		anim_name += "left"
		current_direction = CURRENT_DIRECTION.LEFT
	elif(velocity.normalized() == Vector2.RIGHT):
		anim_name += "right"
		current_direction = CURRENT_DIRECTION.RIGHT
	elif(velocity.normalized() == Vector2.DOWN):
		anim_name += "down"
		current_direction = CURRENT_DIRECTION.DOWN
	elif(velocity.normalized() == Vector2.UP):
		anim_name += "up"
		current_direction = CURRENT_DIRECTION.UP
	else:
		return
		
	var current_frame = get_frame()
	var current_progress = get_frame_progress()
	play(anim_name)
	set_frame_and_progress(current_frame, current_progress)

func _on_character_body_2d_attack() -> void:
	is_attacking = true
	match current_direction:
		CURRENT_DIRECTION.UP:
			play("attack_wooden_up")
		CURRENT_DIRECTION.DOWN:
			play("attack_wooden_down")
		CURRENT_DIRECTION.LEFT:
			play("attack_wooden_left")
		CURRENT_DIRECTION.RIGHT:
			play("attack_wooden_right")


func _on_animation_finished() -> void:
	if(is_attacking):
		is_attacking = false
		attack_ended.emit()
		match current_direction:
			CURRENT_DIRECTION.UP:
				play("up")
			CURRENT_DIRECTION.DOWN:
				play("down")
			CURRENT_DIRECTION.LEFT:
				play("left")
			CURRENT_DIRECTION.RIGHT:
				play("right")
