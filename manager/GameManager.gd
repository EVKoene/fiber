extends Node


var overworld_scene: PackedScene = load("res://overworld/areas/StartingArea.tscn")
var version := "0.0.1"
var testing := true
var main_menu: MainMenu
var current_area: OverworldArea
var is_server := false
@onready var deck := DeckCollection.player_testing

var starting_draw := 1

func go_to_overworld() -> void:
	GameManager.testing = false
	OverworldManager.can_move = true
	var overworld: Node = overworld_scene.instantiate()
	$CenterContainer.hide()
	$DeckButtons.hide()
	add_child(overworld)
	if lobby:
		lobby.queue_free()
		lobby = null


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
		DeckCollection.random_deck:
			deckname = "Random"
		DeckCollection.player_testing:
			deckname = "Testing"

	main_menu.current_deck_label.text = str(
		"Currently: ", deckname, "\nIP Address: ", IP.get_local_addresses()[3]
	)
