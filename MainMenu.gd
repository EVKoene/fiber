extends Control

class_name MainMenu


@export var address := "127.0.0.1"
@export var port = 8910
var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
var overworld_scene := load("res://overworld/areas/StartingArea.tscn")
var tutorial_scene := load("res://singleplayer/Tutorial.tscn")
var peer
var deck := DeckCollection.player_testing
var current_area: OverworldArea


func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	GameManager.main_menu = self
	set_current_deck(random_deck())


func start_single_player_battle(npc_id: int) -> void:
	var npc_data: Dictionary = NPCDatabase.npc_data[npc_id]
	GameManager.add_player_to_gamemanager(
		1, 1, "Player1", deck
	)
	
	GameManager.add_player_to_gamemanager(
			2, 2, npc_data["Name"], npc_data["Deck"]
		)
	start_game()


@rpc("any_peer", "call_local")
func start_game() -> void:
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
	GameManager.add_player_to_gamemanager.rpc_id(
		1, 2, multiplayer.get_unique_id(), "Player2", deck
	)
	GameManager.player_id = multiplayer.get_unique_id()


func connection_failed() -> void:
	print("Failed to connect!")


func random_deck() -> Dictionary:
	var rand_deck: Dictionary = [
		DeckCollection.animal, DeckCollection.magic, DeckCollection.nature, DeckCollection.robot
	].pick_random()
	return rand_deck


func set_current_deck(deck_to_set: Dictionary) -> void:
	deck = deck_to_set
	var deckname: String
	match deck:
		DeckCollection.animal:
			deckname = "Animal"
		DeckCollection.magic:
			deckname = "Magic"
		DeckCollection.nature:
			deckname = "Nature"
		DeckCollection.robot:
			deckname = "Robot"
		DeckCollection.random:
			deckname = "Random"
	
	$DeckButtons/CurrentDeck.text = str(
		"Currently: ", deckname, "\nIP Address: ", IP.get_local_addresses()[3]
	)


func _start_tutorial() -> void:
	var tutorial = tutorial_scene.instantiate()
	tutorial.size = MapSettings.total_screen
	add_child(tutorial)
	$CenterContainer.hide()
	$TestingButton.hide()
	$DeckButtons.hide()


func show_main_menu() -> void:
	$CenterContainer.show()
	$TestingButton.show()
	$DeckButtons.show()


func go_to_overworld() -> void:
	GameManager.testing = false
	GameManager.player_id = 1
	GameManager.is_single_player = true
	current_area = overworld_scene.instantiate()
	$CenterContainer.hide()
	$DeckButtons.hide()
	add_child(current_area)


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
	
	GameManager.add_player_to_gamemanager(
		1, multiplayer.get_unique_id(), "Player1", deck
	)
	GameManager.player_id = multiplayer.get_unique_id()


func _on_join_pressed():
	GameManager.is_player_1 = false
	peer = ENetMultiplayerPeer.new()
	if GameManager.testing:
		peer.create_client(address, port)
	else:
		peer.create_client($CenterContainer/VBoxContainer/IPAddress.text, port)
	
	multiplayer.set_multiplayer_peer(peer)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)


func _on_testing_button_pressed():
	if GameManager.testing:
		set_current_deck(DeckCollection.random_deck)
		$TestingButton.text = "Turn on testing"
		GameManager.testing = false
		$CenterContainer/VBoxContainer/IPAddress.show()
	else:
		$TestingButton.text = "Turn off testing"
		GameManager.testing = true
		$CenterContainer/VBoxContainer/IPAddress.hide()


func _on_animal_deck_button_pressed():
	set_current_deck(DeckCollection.animal)


func _on_magic_deck_button_pressed():
	set_current_deck(DeckCollection.magic)


func _on_nature_deck_button_pressed():
	set_current_deck(DeckCollection.nature)


func _on_robot_deck_button_pressed() -> void:
	set_current_deck(DeckCollection.robot)


func _on_random_deck_button_pressed():
	set_current_deck(random_deck())


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_single_player_pressed() -> void:
	go_to_overworld()


func _on_tutorial_pressed():
	_start_tutorial()
