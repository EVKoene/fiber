extends Node


### SCENES ###
var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
var overworld_scene: PackedScene = load("res://overworld/areas/StartingArea.tscn")

### GENERAL ###
var version := "0.0.1"
var testing := true
var main_menu: MainMenu
var is_server := false

### PLAYER ###
"""
If the players are playing on LAN is_player_1 should always be the same as is_server, because the 
first player will start the game and be made player 1. 
"""
var is_player_1 := false
var p1_id: int
var p2_id: int
var players := {}
var is_single_player := false
var player_id: int  # The player's own id
@onready var deck := DeckCollection.player_testing


#### BATTLE ###
var battle_map
var victory_spaces := []
var turn_manager: TurnManager
var play_spaces := []
var ps_column_row := {}
var zoom_preview: ZoomPreview
var resource_bars := {}
var progress_bars := {}
var resources := {}
# Decks should only be visible to the server
var decks := {}
# cards_in_hand and cards_in_play contain the two player ids as keys with an array containing all 
# the the current card nodes beloning to them. They use the card_in_play_index (cip_index) and
# hand_index.
var cards_in_hand := {}
var cards_in_play := {}
var territories := []

### SINGLEPLAYER ###
var ai_player: AIPlayer
var ai_player_id: int

### OVERWORLD ###
var current_area: OverworldArea


@rpc("any_peer", "call_local")
func add_player(
	player_number: int, p_id: int, player_name: String, p_deck: Dictionary
) -> void:
	if !players.has(p_id):
		players[p_id] = {
			"Name": player_name,
			"PlayerNumber": player_number,
			"ID": p_id,
			"Deck": p_deck,
		}
		if player_number == 1:
			p1_id = p_id
		if player_number == 2:
			p2_id = p_id
	
	if multiplayer.is_server():
		for i in players:
			add_player.rpc(
				players[i]["PlayerNumber"], 
				players[i]["ID"], 
				players[i]["Name"], 
				players[i]["Deck"]
			)
	
	start_game.rpc()


@rpc("any_peer", "call_local")
func start_game() -> void:
	GameManager.main_menu.hide_main_menu()
	var b_map = battle_map_scene.instantiate()
	GameManager.main_menu.add_child(b_map, true)


func start_single_player_battle(npc_id: int) -> void:
	var npc_data: Dictionary = NPCDatabase.npc_data[npc_id]
	if !GameManager.players.has(1):
		GameManager.add_player(
			1, 1, "Player1", GameManager.deck
		)

	GameManager.add_player(2, 2, npc_data["Name"], npc_data["Deck"])
	start_game()

	ai_player = null
	ai_player_id = -1


func opposing_player_id(p_id: int) -> int:
	if p_id == p1_id:
		return p2_id
	else:
		return p1_id

var starting_draw := 1

func go_to_overworld() -> void:
	GameManager.testing = false
	OverworldManager.can_move = true
	var overworld: Node = overworld_scene.instantiate()
	$CenterContainer.hide()
	$DeckButtons.hide()
	add_child(overworld)


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
