extends Node


var lobby_scene := load("res://multiplayer/Lobby.tscn")
@onready var server_manager := ServerManager.new()
var peer
var dedicated_server := false
@export var address := "127.0.0.1"
@export var port = 8910
@export var server_addres = "188.245.54.189"


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
	# This will only work as long as we have max 2 players
	add_player.rpc_id(1, multiplayer.get_unique_id(), str(multiplayer.get_unique_id()), GameManager.deck)


func connection_failed() -> void:
	print("Failed to connect!")


func join_random_game() -> void:
	peer = ENetMultiplayerPeer.new()
	#peer.create_client(server_addres, port)
	peer.create_client(address, port)
	
	multiplayer.set_multiplayer_peer(peer)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)


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
	


func join_lan_game() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	
	multiplayer.set_multiplayer_peer(peer)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)


@rpc("any_peer")
func add_player(player_id: int, player_name: String, deck: Dictionary) -> void:
	if dedicated_server:
		add_player_to_server_lobby(player_id, player_name, deck)
	if !dedicated_server:
		create_lan_lobby.rpc()
		var own_id := multiplayer.get_unique_id()
		for p_id in [player_id, own_id]:
			GameManager.lobby.add_player.rpc_id(
				p_id, own_id, str(own_id), GameManager.deck
			)
			GameManager.lobby.add_player.rpc_id(
				p_id, player_id, player_name, deck
			)


@rpc("any_peer", "call_local")
func create_lan_lobby() -> void:
	var lobby = lobby_scene.instantiate()
	GameManager.main_menu.add_child(lobby)


@rpc("any_peer", "call_local")
func add_player_to_server_lobby(
	p_id: int, player_name: String, p_deck: Dictionary
) -> void:
	server_manager.add_player_to_lobby(p_id, player_name, p_deck)
