extends Control

@export var address := "127.0.0.1"
@export var port = 8910
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


@rpc("call_local", "any_peer")
func start_game() -> void:
	var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
	var battle_map = battle_map_scene.instantiate()
	add_child(battle_map, true)


func peer_connected(id: int) -> void:
	print("Player connected " + str(id))


func peer_disconnected(id: int) -> void:
	print("Player disconnected " + str(id))


func connected_to_server() -> void:
	print("Connected to server!")
	_add_player_to_gamemanager.rpc_id(1, multiplayer.get_unique_id(), "Player1", {})


func connection_failed() -> void:
	print("Failed to connect!")


@rpc("any_peer", "call_local")
func _add_player_to_gamemanager(player_id: int, player_name: String, deck: Dictionary) -> void:
	GameManager.players[player_id] = {
		"Name": player_name,
		"ID": player_id,
		"Deck": deck,
	}


func _on_start_pressed():
	start_game.rpc()


func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	_add_player_to_gamemanager(multiplayer.get_unique_id(), "Player1", {})


func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
