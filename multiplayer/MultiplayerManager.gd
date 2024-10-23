extends Node


@export var address := "127.0.0.1"
@export var port = 8910
@export var server_addres = "188.245.54.189"
var peer
var dedicated_server := false
var n_connected_players := 0


func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		become_dedicated_server_host()
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
	add_player.rpc_id(
		1, multiplayer.get_unique_id(), str(multiplayer.get_unique_id()), GameManager.deck
	)
	GameManager.player_id = multiplayer.get_unique_id()


func connection_failed() -> void:
	print("Failed to connect!")


func join_random_game() -> void:
	peer = ENetMultiplayerPeer.new()
	#peer.create_client(server_addres, port)
	peer.create_client(address, port)
	
	multiplayer.set_multiplayer_peer(peer)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	GameManager.testing = false


func become_dedicated_server_host() -> void:
	dedicated_server = true
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	
	GameManager.is_server = true
	GameManager.testing = false


func become_lan_host() -> void:
	GameManager.is_server = true
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	add_player(multiplayer.get_unique_id(), str(multiplayer.get_unique_id()), GameManager.deck)
	GameManager.player_id = multiplayer.get_unique_id()
	GameManager.testing = false


func join_lan_game() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	
	multiplayer.set_multiplayer_peer(peer)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	GameManager.testing = false


@rpc("any_peer")
func add_player(p_id: int, player_name: String, p_deck: Dictionary) -> void:
	n_connected_players += 1
	GameManager.add_player.rpc_id(1, n_connected_players, p_id, player_name, p_deck)
