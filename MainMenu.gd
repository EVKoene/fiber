extends Control

@export var address := "127.0.0.1"
@export var port = 8910
var peer
var deck := DeckCollection.player_testing_deck

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


@rpc("any_peer", "call_local")
func start_game() -> void:
	var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
	var battle_map = battle_map_scene.instantiate()
	add_child(battle_map, true)
	$CenterContainer.hide()
	$DeckButtons.hide()


func peer_connected(id: int) -> void:
	print("Player connected " + str(id))


func peer_disconnected(id: int) -> void:
	print("Player disconnected " + str(id))


func connected_to_server() -> void:
	print("Connected to server!")
	# This will only work as long as we have max 2 players
	_add_player_to_gamemanager.rpc_id(
		1, 2, multiplayer.get_unique_id(), "Player2", deck
	)
	GameManager.player_id = multiplayer.get_unique_id()


func connection_failed() -> void:
	print("Failed to connect!")


@rpc("any_peer")
func _add_player_to_gamemanager(
	player_number: int, player_id: int, player_name: String, p_deck: Dictionary
) -> void:
	if !GameManager.players.has(player_id):
		GameManager.players[player_id] = {
			"Name": player_name,
			"PlayerNumber": player_number,
			"ID": player_id,
			"Deck": p_deck,
		}
		if player_number == 1:
			GameManager.p1_id = player_id
		if player_number == 2:
			GameManager.p2_id = player_id
	
	if multiplayer.is_server():
		for i in GameManager.players:
			_add_player_to_gamemanager.rpc(
				GameManager.players[i]["PlayerNumber"], 
				GameManager.players[i]["ID"], 
				GameManager.players[i]["Name"], 
				GameManager.players[i]["Deck"]
			)


func _on_start_pressed():
	start_game.rpc()


func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	
	_add_player_to_gamemanager(
		1, multiplayer.get_unique_id(), "Player1", deck
	)
	GameManager.player_id = multiplayer.get_unique_id()
	GameManager.is_player_1 = true


func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	if GameManager.testing:
		peer.create_client(address, port)
	else:
		peer.create_client($CenterContainer/VBoxContainer/IPAddress.text, port)
	
	multiplayer.set_multiplayer_peer(peer)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)


func _on_testing_button_pressed():
	if GameManager.testing:
		$TestingButton.text = "Turn on testing"
		GameManager.testing = false
		$CenterContainer/VBoxContainer/IPAddress.show()
		$DeckButtons.show()
	else:
		$TestingButton.text = "Turn off testing"
		GameManager.testing = true
		$CenterContainer/VBoxContainer/IPAddress.hide()
		$DeckButtons.hide()


func _on_animal_deck_button_pressed():
	deck = DeckCollection.animal_deck
	$DeckButtons/CurrentDeck.text = "Currently: Animal deck"


func _on_magic_deck_button_pressed():
	deck = DeckCollection.magic_deck
	$DeckButtons/CurrentDeck.text = "Currently: Magic deck"


func _on_nature_deck_button_pressed():
	deck = DeckCollection.nature_deck
	$DeckButtons/CurrentDeck.text = "Currently: Nature deck"


func _on_robot_deck_button_pressed():
	deck = DeckCollection.robot_deck
	$DeckButtons/CurrentDeck.text = "Currently: Robot deck"


func _on_exit_pressed():
	get_tree().quit()


func _on_single_player_pressed():
	GameManager.player_id = 1
	GameManager.is_player_1 = true
	_add_player_to_gamemanager(
		1, 1, "Player1", deck
	)
	
	_add_player_to_gamemanager(
			2, 2, "AIOpponent", DeckCollection.opponent_testing_deck
		)
	GameManager.is_single_player = true
	start_game()
