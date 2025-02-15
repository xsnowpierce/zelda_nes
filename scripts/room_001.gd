extends "res://scripts/room_data.gd"

@export var text_print_delay : float = 0.12

func _ready() -> void:
	super()
	set_room_visibility(false)

func awake() -> void:
	is_awake = true
	set_room_visibility(true)
	$dialogue_text.visible_characters = 0
	$dialogue_text2.visible_characters = 0
	$fire.play("appear")
	$fire2.play("appear")
	$old_man.play("default")
	pass
	
func sleep() -> void:
	super()
	set_room_visibility(false)
	pass

func set_room_visibility(value : bool) -> void:
	$dialogue_text.visible = value
	$dialogue_text2.visible = value
	$fire.visible = value
	$fire2.visible = value
	$old_man.visible = value

func start_typing_animation() -> void:
	var dialogue_max_chars = $dialogue_text.get_total_character_count()
	$AudioStreamPlayer.play()
	for character in dialogue_max_chars:
		$dialogue_text.visible_characters += 1
		var delay_time : float = text_print_delay
		while delay_time > 0:
			delay_time -= get_process_delta_time()
			await get_tree().process_frame
	dialogue_max_chars = $dialogue_text2.get_total_character_count()
	for character in dialogue_max_chars:
		$dialogue_text2.visible_characters += 1
		var delay_time : float = text_print_delay
		while delay_time > 0:
			delay_time -= get_process_delta_time()
			await get_tree().process_frame
	$AudioStreamPlayer.stop()
	is_loaded = true

func _on_fire_animation_finished() -> void:
	$fire.play("fire")
	$fire2.play("fire")
	start_typing_animation()
