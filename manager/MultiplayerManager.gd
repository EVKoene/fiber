extends Node


var peer
var dedicated_server := false
@export var address := "127.0.0.1"
@export var port = 8910


func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		dedicated_server = true
		become_host()
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


func peer_connected(id: int) -> void:
	print("Player connected " + str(id))


func peer_disconnected(id: int) -> void:
	print("Player disconnected " + str(id))


func connected_to_server() -> void:
	print("Connected to server!")
	# This will only work as long as we have max 2 players
	GameManager.add_player_to_gamemanager.rpc_id(
		1, 2, multiplayer.get_unique_id(), "Player2", GameManager.deck
	)
	GameManager.player_id = multiplayer.get_unique_id()


func connection_failed() -> void:
	print("Failed to connect!")


func become_host() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	if dedicated_server:
		return
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	
	GameManager.add_player_to_gamemanager(
		1, multiplayer.get_unique_id(), "Player1", GameManager.deck
	)
	GameManager.player_id = multiplayer.get_unique_id()


func join_game() -> void:
	GameManager.is_player_1 = false
	peer = ENetMultiplayerPeer.new()
	if GameManager.testing:
		peer.create_client(address, port)
	else:
		peer.create_client($CenterContainer/VBoxContainer/IPAddress.text, port)
	
	multiplayer.set_multiplayer_peer(peer)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
