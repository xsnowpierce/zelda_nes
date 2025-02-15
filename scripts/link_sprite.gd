extends AnimatedSprite2D

var current_direction : Vector2 = Vector2.UP
var is_attacking : bool = false
signal attack_ended

func set_look_direction(direction: Vector2) -> void:
	var anim_name : String
	if(is_attacking):
		anim_name = "attack_wooden_"
	if(direction == Vector2.LEFT):
		anim_name += "left"
	elif(direction == Vector2.RIGHT):
		anim_name += "right"
	elif(direction == Vector2.DOWN):
		anim_name += "down"
	elif(direction == Vector2.UP):
		anim_name += "up"
	else:
		return
	current_direction = direction
	var current_frame = get_frame()
	var current_progress = get_frame_progress()
	play(anim_name)
	set_frame_and_progress(current_frame, current_progress)
	
func set_current_velocity(velocity : Vector2) -> void:
	if(velocity == Vector2.ZERO and !is_attacking):
		pause()
	else:
		play()
	pass

func _on_character_body_2d_attack() -> void:
	is_attacking = true
	match current_direction:
		Vector2.UP:
			play("attack_wooden_up")
		Vector2.DOWN:
			play("attack_wooden_down")
		Vector2.LEFT:
			play("attack_wooden_left")
		Vector2.RIGHT:
			play("attack_wooden_right")

func _on_animation_finished() -> void:
	if(is_attacking):
		is_attacking = false
		attack_ended.emit()
		match current_direction:
			Vector2.UP:
				play("up")
			Vector2.DOWN:
				play("down")
			Vector2.LEFT:
				play("left")
			Vector2.RIGHT:
				play("right")
