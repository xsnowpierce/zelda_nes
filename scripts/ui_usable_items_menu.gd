extends Control

var game_data : Node

func _ready() -> void:
	game_data = get_tree().get_first_node_in_group("GameData")

func _on_game_pause_menu_opened() -> void:
	apply_stats_to_items()

func _on_game_pause_menu_closed() -> void:
	pass

func apply_stats_to_items() -> void:
	#boomerang
	if(game_data.has_player_flag("obtained_magical_boomerang")):
		$boomerang_slot/TextureRect.frame = 1
		$boomerang_slot/TextureRect.visible = true
	elif(game_data.has_player_flag("obtained_wooden_boomerang")):
		$boomerang_slot/TextureRect.frame = 0
		$boomerang_slot/TextureRect.visible = true
	else:
		$boomerang_slot/TextureRect.visible = false
		
	#bomb
	if(game_data.has_player_flag("obtained_bomb")):
		$bomb_slot/TextureRect.frame = 0
		$bomb_slot/TextureRect.visible = true
	else:
		$bomb_slot/TextureRect.visible = false
		
	#arrows
	if(game_data.has_player_flag("obtained_silver_arrows")):
		$arrow_slot/TextureRect.frame = 1
		$arrow_slot/TextureRect.visible = true
	elif(game_data.has_player_flag("obtained_wooden_arrows")):
		$arrow_slot/TextureRect.frame = 0
		$arrow_slot/TextureRect.visible = true
	else:
		$arrow_slot/TextureRect.visible = false
	
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
	elif(game_data.has_player_flag("obtained_blue_candle")):
		$candle_slot/TextureRect.frame = 0
		$candle_slot/TextureRect.visible = true
	else:
		$candle_slot/TextureRect.visible = false
	
	#whistle
	if(game_data.has_player_flag("obtained_whistle")):
		$whistle_slot/TextureRect.frame = 0
		$whistle_slot/TextureRect.visible = true
	else:
		$whistle_slot/TextureRect.visible = false
		
	#food
	if(game_data.has_player_flag("obtained_food")):
		$food_slot/TextureRect.frame = 0
		$food_slot/TextureRect.visible = true
	else:
		$food_slot/TextureRect.visible = false
	
	#potion
	if(game_data.has_player_flag("obtained_red_potion")):
		$potion_slot/TextureRect.frame = 1
		$potion_slot/TextureRect.visible = true
	elif(game_data.has_player_flag("obtained_blue_potion")):
		$potion_slot/TextureRect.frame = 0
		$potion_slot/TextureRect.visible = true
	else:
		$potion_slot/TextureRect.visible = false
	
	#magic rod
	if(game_data.has_player_flag("obtained_magic_rod")):
		$rod_slot/TextureRect.frame = 0
		$rod_slot/TextureRect.visible = true
	else:
		$rod_slot/TextureRect.visible = false
