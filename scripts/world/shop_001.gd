extends "res://scripts/room_data.gd"

@export var text_print_delay : float = 0.12

func _ready() -> void:
	super()
	set_room_visibility(false)
	set_purchasable_items_visibility(false)

func awake() -> void:
	is_awake = true
	set_room_visibility(true)
	set_purchasable_items_visibility(false)
	$dialogue_text.visible_characters = 0
	$fire.play("appear")
	$fire2.play("appear")
	$npc.play("default")
	pass
	
func sleep() -> void:
	super()
	set_room_visibility(false)
	set_purchasable_items_visibility(false)
	pass

func set_purchasable_items_visibility(value : bool) -> void:
	if(is_instance_valid($ITEM_0)):
		$ITEM_0.visible = value
	if(is_instance_valid($ITEM_1)):
		$ITEM_1.visible = value
	if(is_instance_valid($ITEM_2)):
		$ITEM_2.visible = value
	if(is_instance_valid($purchase_text)):
		$purchase_text.visible = value
	if(is_instance_valid($rupee_sprite)):
		$rupee_sprite.visible = value

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
	set_purchasable_items_visibility(true)
	start_typing_animation()

func post_item_purchased() -> void:
	$dialogue_text.visible = false
	set_purchasable_items_visibility(false)
	$npc.play("disappear")
	await get_tree().create_timer(npc_disappear_time).timeout
	$npc.visible = false

func _on_item_0_item_picked_up() -> void:
	post_item_purchased()


func _on_item_1_item_picked_up() -> void:
	post_item_purchased()


func _on_item_2_item_picked_up() -> void:
	post_item_purchased()
