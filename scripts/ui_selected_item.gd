extends Node

func _on_game_equipment_slot_a_changed(new_item_type: ENUM.KEY_ITEM_TYPE) -> void:
	$TextureRect.frame = get_animation_frame_from_item_type(new_item_type)


func _on_game_equipment_slot_b_changed(new_item_type: ENUM.KEY_ITEM_TYPE) -> void:
	$TextureRect.frame = get_animation_frame_from_item_type(new_item_type)

func get_animation_frame_from_item_type(item_type : ENUM.KEY_ITEM_TYPE) -> int:
	match item_type:
		ENUM.KEY_ITEM_TYPE.WOODEN_BOOMERANG:
			return 1
		ENUM.KEY_ITEM_TYPE.MAGICAL_BOOMERANG:
			return 2
		ENUM.KEY_ITEM_TYPE.BOMB:
			return 3
		ENUM.KEY_ITEM_TYPE.WOODEN_ARROW:
			return 4
		ENUM.KEY_ITEM_TYPE.SILVER_ARROW:
			return 5
		ENUM.KEY_ITEM_TYPE.BLUE_CANDLE:
			return 6
		ENUM.KEY_ITEM_TYPE.RED_CANDLE:
			return 7
		ENUM.KEY_ITEM_TYPE.RECORDER:
			return 8
		ENUM.KEY_ITEM_TYPE.FOOD:
			return 9
		ENUM.KEY_ITEM_TYPE.BLUE_POTION:
			return 11
		ENUM.KEY_ITEM_TYPE.RED_POTION:
			return 12
		ENUM.KEY_ITEM_TYPE.MAGICAL_ROD:
			return 13
		ENUM.KEY_ITEM_TYPE.WOODEN_SWORD:
			return 14
		ENUM.KEY_ITEM_TYPE.WHITE_SWORD:
			return 15
		ENUM.KEY_ITEM_TYPE.DOOR_KEY:
			return 16
		ENUM.KEY_ITEM_TYPE.WOODEN_SHIELD:
			return 17
	return 0
