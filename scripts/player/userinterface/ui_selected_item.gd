extends Node

func _on_game_equipment_slot_a_changed(new_item_type: ENUM.ITEM_TYPE) -> void:
	$TextureRect.frame = get_animation_frame_from_item_type(new_item_type)


func _on_game_equipment_slot_b_changed(new_item_type: ENUM.ITEM_TYPE) -> void:
	$TextureRect.frame = get_animation_frame_from_item_type(new_item_type)

func get_animation_frame_from_item_type(item_type : ENUM.ITEM_TYPE) -> int:
	match item_type:
		ENUM.ITEM_TYPE.WOODEN_BOOMERANG:
			return 1
		ENUM.ITEM_TYPE.MAGICAL_BOOMERANG:
			return 2
		ENUM.ITEM_TYPE.BOMB:
			return 3
		ENUM.ITEM_TYPE.WOODEN_ARROW:
			return 4
		ENUM.ITEM_TYPE.SILVER_ARROW:
			return 5
		ENUM.ITEM_TYPE.BLUE_CANDLE:
			return 6
		ENUM.ITEM_TYPE.RED_CANDLE:
			return 7
		ENUM.ITEM_TYPE.RECORDER:
			return 8
		ENUM.ITEM_TYPE.FOOD:
			return 9
		ENUM.ITEM_TYPE.BLUE_POTION:
			return 11
		ENUM.ITEM_TYPE.RED_POTION:
			return 12
		ENUM.ITEM_TYPE.MAGICAL_ROD:
			return 13
		ENUM.ITEM_TYPE.WOODEN_SWORD:
			return 14
		ENUM.ITEM_TYPE.WHITE_SWORD:
			return 15
		ENUM.ITEM_TYPE.DOOR_KEY:
			return 16
		ENUM.ITEM_TYPE.WOODEN_SHIELD:
			return 17
	return 0
