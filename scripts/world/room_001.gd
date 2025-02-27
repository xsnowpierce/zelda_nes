extends "res://scripts/room_data.gd"

@export var text_print_delay : float = 0.12
var has_item : bool

func _ready() -> void:
	super()
	set_room_visibility(false)

func awake() -> void:
	if(is_instance_valid($KeyItem)):
		$"Key Item/AnimatedSprite2D".visible = false
	if(get_tree().get_first_node_in_group("GameData").has_player_flag("obtained_wooden_sword")):
		set_room_visibility(false)
		$fire.visible = true
		$fire2.visible = true
		has_item = true
		is_loaded = true
		$"Key Item".queue_free()
	else:
		set_room_visibility(true)
		$dialogue_text.visible_characters = 0
		$dialogue_text2.visible_characters = 0
		$old_man.play("default")
	is_awake = true
	$fire.play("appear")
	$fire2.play("appear")

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
		await get_tree().create_timer(text_print_delay).timeout
	dialogue_max_chars = $dialogue_text2.get_total_character_count()
	for character in dialogue_max_chars:
		$dialogue_text2.visible_characters += 1
		await get_tree().create_timer(text_print_delay).timeout
	$AudioStreamPlayer.stop()
	is_loaded = true

func _on_fire_animation_finished() -> void:
	if(!is_awake):
		return
	$fire.play("fire")
	$fire2.play("fire")
	if(!has_item):
		$"Key Item/AnimatedSprite2D".visible = true
		start_typing_animation()

func _on_key_item_item_picked_up() -> void:
	has_item = false
	$dialogue_text.visible = false
	$dialogue_text2.visible = false
	$old_man.play("disappear")
	await get_tree().create_timer(npc_disappear_time).timeout
	$old_man.visible = false
