extends Control

var game_data : Node

func _ready() -> void:
	game_data = get_tree().get_first_node_in_group("GameData")

func _on_game_pause_menu_opened() -> void:
	apply_stats_to_items()


func _on_game_pause_menu_closed() -> void:
	pass # Replace with function body.

func apply_stats_to_items() -> void:
	
	#raft
	if(game_data.has_player_flag("obtained_raft")):
		$raft_slot/TextureRect.visible = true
	else:
		$raft_slot/TextureRect.visible = false
		
	#book of magic
	if(game_data.has_player_flag("obtained_book_of_magic")):
		$book_slot/TextureRect.visible = true
	else:
		$book_slot/TextureRect.visible = false
		
	#blue and red ring
	if(game_data.has_player_flag("obtained_red_ring")):
		$ring_slot/TextureRect.visible = true
	elif(game_data.has_player_flag("obtained_blue_ring")):
		$ring_slot/TextureRect.visible = true
	else:
		$ring_slot/TextureRect.visible = false
	
	#ladder
	if(game_data.has_player_flag("obtained_ladder")):
		$ladder_slot/TextureRect.visible = true
	else:
		$ladder_slot/TextureRect.visible = false
	
	#magical key
	if(game_data.has_player_flag("obtained_magical_key")):
		$key_slot/TextureRect.visible = true
	else:
		$key_slot/TextureRect.visible = false
	
	#power bracelet
	if(game_data.has_player_flag("obtained_power_bracelet")):
		$bracelet_slot/TextureRect.visible = true
	else:
		$bracelet_slot/TextureRect.visible = false
