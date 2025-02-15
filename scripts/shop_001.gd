extends "res://scripts/room_data.gd"

@export var text_print_delay : float = 0.12

func _ready() -> void:
	super()
	set_room_visibility(false)

func awake() -> void:
	is_awake = true
	set_room_visibility(true)
	$dialogue_text.visible_characters = 0
	$fire.play("appear")
	$fire2.play("appear")
	$npc.play("default")
	pass
	
func sleep() -> void:
	super()
	set_room_visibility(false)
	pass

func set_room_visibility(value : bool) -> void:
	$dialogue_text.visible = value
	$fire.visible = value
	$fire2.visible = value
	$npc.visible = value

func start_typing_animation() -> void:
	var dialogue_max_chars = $dialogue_text.get_total_character_count()
	$AudioStreamPlayer.play()
	for character in dialogue_max_chars:
		$dialogue_text.visible_characters += 1
		await get_tree().create_timer(text_print_delay).timeout
	$AudioStreamPlayer.stop()
	is_loaded = true

func _on_fire_animation_finished() -> void:
	if(!is_awake):
		return
	$fire.play("fire")
	$fire2.play("fire")
	start_typing_animation()
