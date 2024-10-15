extends Control

class_name MainMenu


var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
var overworld_scene := load("res://overworld/areas/StartingArea.tscn")
var tutorial_scene := load("res://singleplayer/Tutorial.tscn")
var current_area: OverworldArea


func _ready():
	GameManager.main_menu = self
	set_current_deck(random_deck())


func start_single_player_battle(npc_id: int) -> void:
	var npc_data: Dictionary = NPCDatabase.npc_data[npc_id]
	if !GameManager.players.has(1):
		GameManager.add_player_to_gamemanager(
			1, 1, "Player1", GameManager.deck
		)
	
	GameManager.add_player_to_gamemanager(
			2, 2, npc_data["Name"], npc_data["Deck"]
		)
	start_game()


@rpc("any_peer", "call_local")
func start_game() -> void:
	var battle_map = battle_map_scene.instantiate()
	add_child(battle_map, true)
	$TestingButton.hide()
	$CenterContainer.hide()
	$DeckButtons.hide()
	OverworldManager.can_move = true


func random_deck() -> Dictionary:
	var rand_deck: Dictionary = [
		DeckCollection.animal, DeckCollection.magic, DeckCollection.nature, DeckCollection.robot
	].pick_random()
	return rand_deck


func set_current_deck(deck_to_set: Dictionary) -> void:
	GameManager.deck = deck_to_set
	var deckname: String
	match GameManager.deck:
		DeckCollection.animal:
			deckname = "Animal"
		DeckCollection.magic:
			deckname = "Magic"
		DeckCollection.nature:
			deckname = "Nature"
		DeckCollection.robot:
			deckname = "Robot"
		DeckCollection.random_deck:
			deckname = "Random"
		DeckCollection.player_testing:
			deckname = "Testing"
	
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
	GameManager.clean_manager()
	if current_area:
		current_area.queue_free()
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
	MultiplayerManager.become_host()

func _on_join_pressed():
	MultiplayerManager.join_game()
	

func _on_testing_button_pressed():
	if GameManager.testing:
		set_current_deck(DeckCollection.random_deck)
		$TestingButton.text = "Turn on testing"
		GameManager.testing = false
		$CenterContainer/VBoxContainer/IPAddress.show()
	else:
		set_current_deck(DeckCollection.player_testing)
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
