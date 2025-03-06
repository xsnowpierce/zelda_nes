extends Entity

@export var item_type : ENUM.ITEM_TYPE = ENUM.ITEM_TYPE.NULL
@export var rupee_value_override : int = -1
var is_key_item : bool
signal item_picked_up
var sfxplayer : SFXPlayer
var times_picked_up : int

func _ready() -> void:
	super()
	set_item_type(item_type)
	sfxplayer = get_tree().get_first_node_in_group("SFXPlayer")

func set_item_type(type : ENUM.ITEM_TYPE) -> void:
	item_type = type
	if(GameSettings.is_key_item(type)):
		is_key_item = true
	match type:
		ENUM.ITEM_TYPE.BLUE_CANDLE:
			$"Dropped Item/AnimatedSprite2D".play("blue_candle")
		ENUM.ITEM_TYPE.BLUE_POTION:
			$"Dropped Item/AnimatedSprite2D".play("blue_potion")
		ENUM.ITEM_TYPE.BLUE_RUPEE:
			$"Dropped Item/AnimatedSprite2D".play("blue_rupee")
		ENUM.ITEM_TYPE.BOMB:
			$"Dropped Item/AnimatedSprite2D".play("bomb")
		ENUM.ITEM_TYPE.BOW:
			$"Dropped Item/AnimatedSprite2D".play("bow")
		ENUM.ITEM_TYPE.COMPASS:
			$"Dropped Item/AnimatedSprite2D".play("compass")
		ENUM.ITEM_TYPE.FAIRY:
			# TODO spawn fairy here
			queue_free()
			pass
		ENUM.ITEM_TYPE.FOOD:
			$"Dropped Item/AnimatedSprite2D".play("food")
		ENUM.ITEM_TYPE.GREEN_RUPEE:
			$"Dropped Item/AnimatedSprite2D".play("green_rupee")
		ENUM.ITEM_TYPE.HEART:
			$"Dropped Item/AnimatedSprite2D".play("heart")
		ENUM.ITEM_TYPE.HEART_CONTAINER:
			$"Dropped Item/AnimatedSprite2D".play("heart_container")
		ENUM.ITEM_TYPE.DOOR_KEY:
			$"Dropped Item/AnimatedSprite2D".play("key")
		ENUM.ITEM_TYPE.LETTER:
			$"Dropped Item/AnimatedSprite2D".play("letter")
		ENUM.ITEM_TYPE.MAGICAL_BOOMERANG:
			$"Dropped Item/AnimatedSprite2D".play("magical_boomerang")
		ENUM.ITEM_TYPE.MAGICAL_ROD:
			$"Dropped Item/AnimatedSprite2D".play("magical_rod")
		ENUM.ITEM_TYPE.MAGICAL_SHIELD:
			$"Dropped Item/AnimatedSprite2D".play("magical_shield")
		ENUM.ITEM_TYPE.MAGICAL_SWORD:
			$"Dropped Item/AnimatedSprite2D".play("magical_sword")
		ENUM.ITEM_TYPE.ORANGE_MAP:
			$"Dropped Item/AnimatedSprite2D".play("orange_map")
		ENUM.ITEM_TYPE.RECORDER:
			$"Dropped Item/AnimatedSprite2D".play("recorder")
		ENUM.ITEM_TYPE.RED_CANDLE:
			$"Dropped Item/AnimatedSprite2D".play("red_candle")
		ENUM.ITEM_TYPE.RED_POTION:
			$"Dropped Item/AnimatedSprite2D".play("red_potion")
		ENUM.ITEM_TYPE.SILVER_ARROW:
			$"Dropped Item/AnimatedSprite2D".play("silver_arrow")
		ENUM.ITEM_TYPE.TIMER:
			$"Dropped Item/AnimatedSprite2D".play("timer")
		ENUM.ITEM_TYPE.TRIFORCE_PIECE:
			$"Dropped Item/AnimatedSprite2D".play("triforce_piece")
		ENUM.ITEM_TYPE.WHITE_SWORD:
			$"Dropped Item/AnimatedSprite2D".play("white_sword")
		ENUM.ITEM_TYPE.WOODEN_ARROW:
			$"Dropped Item/AnimatedSprite2D".play("wooden_arrow")
		ENUM.ITEM_TYPE.WOODEN_BOOMERANG:
			$"Dropped Item/AnimatedSprite2D".play("wooden_boomerang")
		ENUM.ITEM_TYPE.WOODEN_SWORD:
			$"Dropped Item/AnimatedSprite2D".play("wooden_sword")

func _on_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Player_Bomb")):
		return
	if(times_picked_up > 0):
		return
	times_picked_up += 1
	var game_data : GameData = get_tree().get_first_node_in_group("GameData")
	match item_type:
		ENUM.ITEM_TYPE.GREEN_RUPEE:
			if(rupee_value_override != -1):
				game_data.change_rupees(rupee_value_override)
			else:
				game_data.change_rupees(1)
			sfxplayer.play_sound(SFXPlayer.SFX.RUPEE_PICKUP)
		ENUM.ITEM_TYPE.BLUE_RUPEE:
			if(rupee_value_override != -1):
				game_data.change_rupees(rupee_value_override)
			else:
				game_data.change_rupees(5)
			sfxplayer.play_sound(SFXPlayer.SFX.RUPEE_PICKUP)
		ENUM.ITEM_TYPE.HEART:
			game_data.player_gain_heart(2)
			sfxplayer.play_sound(SFXPlayer.SFX.HEART_PICKUP)
		ENUM.ITEM_TYPE.DOOR_KEY:
			game_data.change_keys(1)
			sfxplayer.play_sound(SFXPlayer.SFX.HEART_PICKUP)
		ENUM.ITEM_TYPE.COMPASS:
			game_data.picked_up_dungeon_compass()
			sfxplayer.play_sound(SFXPlayer.SFX.HEART_PICKUP)
		ENUM.ITEM_TYPE.HEART_CONTAINER:
			game_data.change_max_hearts(2)
			sfxplayer.play_sound(SFXPlayer.SFX.HEART_CONTAINER_PICKUP)
		ENUM.ITEM_TYPE.TRIFORCE_PIECE:
			pass
	if(is_key_item):
		game_data.add_player_flag(get_obtain_player_flag_from_item_type(item_type))
		game_data.player_pickup_key_item(item_type)
	$"Dropped Item/AnimatedSprite2D".visible = false
	item_picked_up.emit()
	queue_free()

func get_obtain_player_flag_from_item_type(get_item_type : ENUM.ITEM_TYPE) -> String:
	match get_item_type:
		ENUM.ITEM_TYPE.WOODEN_BOOMERANG:
			return "obtained_wooden_boomerang"
		ENUM.ITEM_TYPE.MAGICAL_BOOMERANG:
			return "obtained_magical_boomerang"
		ENUM.ITEM_TYPE.BOMB:
			return "obtained_bomb"
		ENUM.ITEM_TYPE.WOODEN_ARROW:
			return "obtained_wooden_arrows"
		ENUM.ITEM_TYPE.SILVER_ARROW:
			return "obtained_silver_arrows"
		ENUM.ITEM_TYPE.BLUE_CANDLE:
			return "obtained_blue_candle"
		ENUM.ITEM_TYPE.RED_CANDLE:
			return "obtained_red_candle"
		ENUM.ITEM_TYPE.RECORDER:
			return "obtained_whistle"
		ENUM.ITEM_TYPE.FOOD:
			return "obtained_food"
		ENUM.ITEM_TYPE.BLUE_POTION:
			return "obtained_blue_potion"
		ENUM.ITEM_TYPE.RED_POTION:
			return "obtained_red_potion"
		ENUM.ITEM_TYPE.MAGICAL_ROD:
			return "obtained_magical_rod"
		ENUM.ITEM_TYPE.WOODEN_SWORD:
			return "obtained_wooden_sword"
		ENUM.ITEM_TYPE.WHITE_SWORD:
			return "obtained_white_sword"
		ENUM.ITEM_TYPE.DOOR_KEY:
			return "obtained_door_key"
		ENUM.ITEM_TYPE.WOODEN_SHIELD:
			return "obtained_wooden_shield"
		ENUM.ITEM_TYPE.MAGICAL_SHIELD:
			return "obtained_magical_shield"
		ENUM.ITEM_TYPE.BOW:
			return "obtained_bow"
	return "null"

func awake() -> void:
	$"Dropped Item/AnimatedSprite2D".visible = true

func sleep() -> void:
	$"Dropped Item/AnimatedSprite2D".visible = false
