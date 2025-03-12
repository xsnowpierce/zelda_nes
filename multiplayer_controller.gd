extends Control

@export var game_manager : GameManager
@export var address : String = "127.0.0.1"
@export var port : int = 8910
@export var skip_multiplayer_screen : bool = false

var enet_peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	if(skip_multiplayer_screen):
		_on_singleplayer_pressed()

func _on_host_pressed() -> void:
	hide()
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(game_manager.add_player)
	game_manager.add_player(multiplayer.get_unique_id())

func _on_join_pressed() -> void:
	hide()
	enet_peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = enet_peer

func _on_singleplayer_pressed() -> void:
	game_manager.add_player(1)
	hide()
