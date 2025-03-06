extends AnimatedSprite2D

class_name LinkPickupItemSprite

var default_position : Vector2 = Vector2(-8, -24)
var is_wide_sprite : bool = false

func set_item_type(type : ENUM.ITEM_TYPE) -> void:
	position = default_position
	is_wide_sprite = false
	match type:
		ENUM.ITEM_TYPE.BLUE_CANDLE:
			play("blue_candle")
		ENUM.ITEM_TYPE.BLUE_POTION:
			play("blue_potion")
		ENUM.ITEM_TYPE.BLUE_RUPEE:
			play("blue_rupee")
		ENUM.ITEM_TYPE.BOMB:
			play("bomb")
			position = default_position + Vector2(0, 2)
		ENUM.ITEM_TYPE.BOW:
			play("bow")
		ENUM.ITEM_TYPE.COMPASS:
			play("compass")
		ENUM.ITEM_TYPE.FOOD:
			play("food")
		ENUM.ITEM_TYPE.GREEN_RUPEE:
			play("green_rupee")
		ENUM.ITEM_TYPE.HEART:
			play("heart")
		ENUM.ITEM_TYPE.HEART_CONTAINER:
			play("heart_container")
		ENUM.ITEM_TYPE.DOOR_KEY:
			play("key")
		ENUM.ITEM_TYPE.LETTER:
			play("letter")
		ENUM.ITEM_TYPE.MAGICAL_BOOMERANG:
			play("magical_boomerang")
			position = default_position + Vector2(0, 5)
		ENUM.ITEM_TYPE.MAGICAL_ROD:
			play("magical_rod")
		ENUM.ITEM_TYPE.MAGICAL_SHIELD:
			play("magical_shield")
			position = default_position + Vector2(0, 2)
		ENUM.ITEM_TYPE.MAGICAL_SWORD:
			play("magical_sword")
		ENUM.ITEM_TYPE.ORANGE_MAP:
			play("orange_map")
		ENUM.ITEM_TYPE.RECORDER:
			play("recorder")
		ENUM.ITEM_TYPE.RED_CANDLE:
			play("red_candle")
		ENUM.ITEM_TYPE.RED_POTION:
			play("red_potion")
		ENUM.ITEM_TYPE.SILVER_ARROW:
			play("silver_arrow")
		ENUM.ITEM_TYPE.TIMER:
			play("timer")
		ENUM.ITEM_TYPE.TRIFORCE_PIECE:
			play("triforce_piece")
			position = default_position + Vector2(0, 2)
			is_wide_sprite = true
		ENUM.ITEM_TYPE.WHITE_SWORD:
			play("white_sword")
		ENUM.ITEM_TYPE.WOODEN_ARROW:
			play("wooden_arrow")
		ENUM.ITEM_TYPE.WOODEN_BOOMERANG:
			play("wooden_boomerang")
			position = default_position + Vector2(0, 5)
		ENUM.ITEM_TYPE.WOODEN_SWORD:
			play("wooden_sword")
