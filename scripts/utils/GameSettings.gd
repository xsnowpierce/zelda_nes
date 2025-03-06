extends Node

static var camera_is_moving : bool = false
static var screen_boundaries : Vector4 = Vector4(-128, 128, -96, 80)
static var map_screen_size : Vector2i = Vector2i(256, 176)

static func is_key_item(item : ENUM.ITEM_TYPE) -> bool:
	match item:
		ENUM.ITEM_TYPE.BOMB:
			return true
		ENUM.ITEM_TYPE.BLUE_CANDLE:
			return true
		ENUM.ITEM_TYPE.BLUE_POTION:
			return true
		ENUM.ITEM_TYPE.BOW:
			return true
		ENUM.ITEM_TYPE.FOOD:
			return true
		ENUM.ITEM_TYPE.LETTER:
			return true
		ENUM.ITEM_TYPE.MAGICAL_BOOMERANG:
			return true
		ENUM.ITEM_TYPE.MAGICAL_ROD:
			return true
		ENUM.ITEM_TYPE.MAGICAL_SHIELD:
			return true
		ENUM.ITEM_TYPE.MAGICAL_SWORD:
			return true
		ENUM.ITEM_TYPE.RECORDER:
			return true
		ENUM.ITEM_TYPE.RED_CANDLE:
			return true
		ENUM.ITEM_TYPE.RED_POTION:
			return true
		ENUM.ITEM_TYPE.TRIFORCE_PIECE:
			return true
		ENUM.ITEM_TYPE.WHITE_SWORD:
			return true
		ENUM.ITEM_TYPE.WOODEN_BOOMERANG:
			return true
		ENUM.ITEM_TYPE.WOODEN_SHIELD:
			return true
		ENUM.ITEM_TYPE.WOODEN_SWORD:
			return true
	return false
