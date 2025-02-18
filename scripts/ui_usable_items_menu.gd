extends Control

var game_data : Node

var item_slots : Array[ENUM.KEY_ITEM_TYPE]

func _ready() -> void:
	game_data = get_tree().get_first_node_in_group("GameData")

func _on_game_pause_menu_opened() -> void:
	apply_stats_to_items()

func _on_game_pause_menu_closed() -> void:
	pass

func apply_stats_to_items() -> void:
	var item_array : Array[ENUM.KEY_ITEM_TYPE]
	#boomerang
	if(game_data.has_player_flag("obtained_magical_boomerang")):
		$boomerang_slot/TextureRect.frame = 1
		$boomerang_slot/TextureRect.visible = true
		item_array.insert(0, ENUM.KEY_ITEM_TYPE.MAGICAL_BOOMERANG)
	elif(game_data.has_player_flag("obtained_wooden_boomerang")):
		$boomerang_slot/TextureRect.frame = 0
		$boomerang_slot/TextureRect.visible = true
		item_array.insert(0, ENUM.KEY_ITEM_TYPE.WOODEN_BOOMERANG)
	else:
		$boomerang_slot/TextureRect.visible = false
		item_array.insert(0, ENUM.KEY_ITEM_TYPE.NULL)
		
	#bomb
	if(game_data.has_player_flag("obtained_bomb")):
		$bomb_slot/TextureRect.frame = 0
		$bomb_slot/TextureRect.visible = true
		item_array.insert(1, ENUM.KEY_ITEM_TYPE.BOMB)
	else:
		$bomb_slot/TextureRect.visible = false
		item_array.insert(1, ENUM.KEY_ITEM_TYPE.NULL)
		
	#arrows
	if(game_data.has_player_flag("obtained_silver_arrows")):
		$arrow_slot/TextureRect.frame = 1
		$arrow_slot/TextureRect.visible = true
		item_array.insert(2, ENUM.KEY_ITEM_TYPE.SILVER_ARROW)
	elif(game_data.has_player_flag("obtained_wooden_arrows")):
		$arrow_slot/TextureRect.frame = 0
		$arrow_slot/TextureRect.visible = true
		item_array.insert(2, ENUM.KEY_ITEM_TYPE.WOODEN_ARROW)
	else:
		$arrow_slot/TextureRect.visible = false
		item_array.insert(2, ENUM.KEY_ITEM_TYPE.NULL)
	
	#bow
	if(game_data.has_player_flag("obtained_bow")):
		$bow_slot/TextureRect.frame = 0
		$bow_slot/TextureRect.visible = true
	else:
		$bow_slot/TextureRect.visible = false
	
	#candle
	if(game_data.has_player_flag("obtained_red_candle")):
		$candle_slot/TextureRect.frame = 1
		$candle_slot/TextureRect.visible = true
		item_array.insert(3, ENUM.KEY_ITEM_TYPE.RED_CANDLE)
	elif(game_data.has_player_flag("obtained_blue_candle")):
		$candle_slot/TextureRect.frame = 0
		$candle_slot/TextureRect.visible = true
		item_array.insert(3, ENUM.KEY_ITEM_TYPE.BLUE_CANDLE)
	else:
		$candle_slot/TextureRect.visible = false
		item_array.insert(3, ENUM.KEY_ITEM_TYPE.NULL)
	
	#whistle
	if(game_data.has_player_flag("obtained_whistle")):
		$whistle_slot/TextureRect.frame = 0
		$whistle_slot/TextureRect.visible = true
		item_array.insert(4, ENUM.KEY_ITEM_TYPE.RECORDER)
	else:
		$whistle_slot/TextureRect.visible = false
		item_array.insert(4, ENUM.KEY_ITEM_TYPE.NULL)
		
	#food
	if(game_data.has_player_flag("obtained_food")):
		$food_slot/TextureRect.frame = 0
		$food_slot/TextureRect.visible = true
		item_array.insert(5, ENUM.KEY_ITEM_TYPE.FOOD)
	else:
		$food_slot/TextureRect.visible = false
		item_array.insert(5, ENUM.KEY_ITEM_TYPE.NULL)
	
	#potion
	if(game_data.has_player_flag("obtained_red_potion")):
		$potion_slot/TextureRect.frame = 1
		$potion_slot/TextureRect.visible = true
		item_array.insert(6, ENUM.KEY_ITEM_TYPE.RED_POTION)
	elif(game_data.has_player_flag("obtained_blue_potion")):
		$potion_slot/TextureRect.frame = 0
		$potion_slot/TextureRect.visible = true
		item_array.insert(6, ENUM.KEY_ITEM_TYPE.BLUE_POTION)
	else:
		$potion_slot/TextureRect.visible = false
		item_array.insert(6, ENUM.KEY_ITEM_TYPE.NULL)
	
	#magic rod
	if(game_data.has_player_flag("obtained_magic_rod")):
		$rod_slot/TextureRect.frame = 0
		$rod_slot/TextureRect.visible = true
		item_array.insert(7, ENUM.KEY_ITEM_TYPE.MAGICAL_ROD)
	else:
		$rod_slot/TextureRect.visible = false
		item_array.insert(7, ENUM.KEY_ITEM_TYPE.NULL)
	item_slots = item_array
