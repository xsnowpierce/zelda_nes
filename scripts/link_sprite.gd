extends AnimatedSprite2D

class_name LinkSprite

enum TUNIC_TYPE {GREEN, RED, WHITE} 

var hit_effect_length : float = 0.8
var hit_effect_colour_change_time : float = 0.1
var current_direction : Vector2 = Vector2.UP
var is_attacking : bool = false
@export var default_sprite_palette : LinkSpriteHitColour
@export var red_tunic_sprite_palette : LinkSpriteHitColour
@export var white_tunic_sprite_palette : LinkSpriteHitColour
@export var hit_effect_sprite_palette_1 : LinkSpriteHitColour
@export var hit_effect_sprite_palette_2 : LinkSpriteHitColour
@export var hit_effect_sprite_palette_3 : LinkSpriteHitColour
var current_sprite_palette : LinkSpriteHitColour
var is_hit_flash : bool
var hit_flash_timer : float
signal attack_ended

func _ready() -> void:
	set_current_tunic(TUNIC_TYPE.GREEN)

func set_current_tunic(tunic_type : TUNIC_TYPE) -> void:
	match tunic_type:
		TUNIC_TYPE.GREEN:
			current_sprite_palette = default_sprite_palette
		TUNIC_TYPE.RED:
			current_sprite_palette = red_tunic_sprite_palette
		TUNIC_TYPE.WHITE:
			current_sprite_palette = white_tunic_sprite_palette
	set_colour_palette(current_sprite_palette)

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
	if(direction != Vector2.ZERO):
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

func _on_link_movement_sprite_update(movement: Vector2, velocity: Vector2) -> void:
	set_look_direction(movement)
	set_current_velocity(velocity)

func hit_effect() -> void:
	hit_flash_timer = hit_effect_length
	if(is_hit_flash):
		return
	is_hit_flash = true
	var hit_change_timer : float = hit_effect_colour_change_time
	var times_changed : int = 1
	while hit_flash_timer > 0:
		hit_flash_timer -= get_process_delta_time()
		hit_change_timer -= get_process_delta_time()
		if(hit_change_timer <= 0):
			hit_change_timer = hit_effect_colour_change_time
			if(times_changed >= 4):
				times_changed = 0
			match times_changed:
				1:
					set_colour_palette(hit_effect_sprite_palette_1)
				2:
					set_colour_palette(hit_effect_sprite_palette_2)
				3:
					set_colour_palette(hit_effect_sprite_palette_3)
				_:
					set_colour_palette(default_sprite_palette)
			times_changed += 1
		await get_tree().process_frame
	set_colour_palette(default_sprite_palette)
	is_hit_flash = false

func set_colour_palette(colour_set : LinkSpriteHitColour) -> void:
	material.set("shader_parameter/NEW_COLOUR_1", colour_to_vector4(colour_set.tunic_colour))
	material.set("shader_parameter/NEW_COLOUR_2", colour_to_vector4(colour_set.hair_colour))
	material.set("shader_parameter/NEW_COLOUR_3", colour_to_vector4(colour_set.skin_colour))

func colour_to_vector4(colour : Color) -> Vector4:
	var r : float = colour.r
	var g : float = colour.g
	var b : float = colour.b
	return Vector4(r, g, b, 1)
