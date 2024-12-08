extends Node


#TODO: This file desperately needs to be split into several smaller files, but I can't find a
# setup that makes sense.
### SCENES ###
var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
var overworld_scene: PackedScene = load("res://overworld/areas/StartingArea.tscn")
@onready var turn_manager_scene: PackedScene = preload("res://manager/TurnManager.tscn")

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
var is_single_player := true
var player_id: int  # The player's own id
@onready var deck: Dictionary : get = _get_current_deck


#### BATTLE ###
var is_ready_to_play := false
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
var starting_draw := 1

### SINGLEPLAYER ###
var ai_player: AIPlayer
var ai_player_id: int

### OVERWORLD ###
var current_scene: Variant


### DECKBUILDER ###
@onready var save_path := "user://savedata/"
@onready var collections_path := str(save_path, "collections.ini")
var deck_builder: DeckBuilder


@rpc("any_peer", "call_local")
func add_player(
	player_number: int, p_id: int, player_name: String, p_deck: Dictionary,
	npc_id: int = -1
) -> void:
	if !players.has(p_id):
		players[p_id] = {
			"Name": player_name,
			"PlayerNumber": player_number,
			"ID": p_id,
			"Deck": p_deck,
			"NPCID": npc_id,
		}
		if player_number == 1:
			p1_id = p_id
			if multiplayer.get_unique_id() == p1_id:
				is_player_1 = true
		if player_number == 2:
			p2_id = p_id
	
	if is_server and player_number == 2 and !is_single_player:
		for i in players:
			add_player.rpc_id(
				p2_id,
				players[i]["PlayerNumber"], 
				players[i]["ID"], 
				players[i]["Name"], 
				players[i]["Deck"],
				players[i]["NPCID"]
			)
			if MultiplayerManager.dedicated_server:
				add_player.rpc_id(
					p1_id,
					players[i]["PlayerNumber"], 
					players[i]["ID"], 
					players[i]["Name"], 
					players[i]["Deck"],
					players[i]["NPCID"]
				)
		
		main_menu.show_start_game_button.rpc()


func setup_savefile() -> void:
	if !FileAccess.file_exists(collections_path):
		var config := ConfigFile.new()
		var create_dir_error := DirAccess.make_dir_recursive_absolute(save_path)
		if create_dir_error:
			print("Error creating directory: ", error_string(create_dir_error))
		config.set_value("deck_data", "decks", DeckCollection.starter_decks)
		config.set_value("deck_data", "current_deck_id", DeckCollection.random_starter_deck_id())
		var save_error := config.save(collections_path)
		if save_error:
			print("Error creating collections file: ", error_string(save_error))
		_setup_card_collection(config)


func _setup_card_collection(config: ConfigFile) -> void:
	var cards := {}
	for starter_deck in [
		DeckCollection.decks[DeckCollection.deck_ids.PASSION_STARTER], 
		DeckCollection.decks[DeckCollection.deck_ids.IMAGINATION_STARTER], 
		DeckCollection.decks[DeckCollection.deck_ids.GROWTH_STARTER], 
		DeckCollection.decks[DeckCollection.deck_ids.LOGIC_STARTER],
	]:
		for c in starter_deck["Cards"].keys():
			cards[c] = starter_deck["Cards"][c]
	
	config.set_value("card_collection", "cards", cards)
	var save_error := config.save(collections_path)
	if save_error:
		print("Error creating card collection: ", error_string(save_error))


@rpc("any_peer", "call_local")
func start_game() -> void:
	main_menu.hide_main_menu()
	var b_map = battle_map_scene.instantiate()
	GameManager.current_scene = b_map
	main_menu.add_child(b_map, true)


func start_single_player_battle(npc_id: int) -> void:
	ai_player = null
	ai_player_id = -1
	var npc_data: Dictionary = NPCDatabase.npc_data[npc_id]
	if !players.has(1):
		add_player(
			1, 1, "Player1", deck
		)
	player_id = 1

	add_player(2, 2, npc_data["Name"], npc_data["Deck"], npc_id)
	start_game()



func opposing_player_id(p_id: int) -> int:
	if p_id == p1_id:
		return p2_id
	else:
		return p1_id


func set_current_deck(deck_id: int) -> void:
	var config := ConfigFile.new()
	config.load(collections_path)
	config.set_value("deck_data", "current_deck_id", deck_id)
	var save_error := config.save(collections_path)
	if save_error:
		print("Error setting deck: ", error_string(save_error))
	
	main_menu.current_deck_label.text = str(
		"Currently: ", deck["DeckName"], "\nIP Address: ", IP.get_local_addresses()[3]
	)


@rpc("any_peer")
func setup_game() -> void:
	_set_cards_in_hand_and_play.rpc()
	if is_single_player:
		_create_resources()
	elif !is_single_player:
		for i in [1, p1_id, p2_id]:
			_create_resources.rpc_id(i)
	_add_turn_managers()
	_add_decks()
	if !battle_map.is_tutorial:
		_start_first_turn()
	else:
		Tutorial.start_tutorial()


func _add_turn_managers() -> void:
	var t_manager = turn_manager_scene.instantiate()
	main_menu.add_child(t_manager, true)


func _add_decks() -> void:
	for p_id in players:
		var deck_data: Dictionary = players[p_id]["Deck"]
		decks[p_id] = Deck.new(p_id, deck_data["Cards"], deck_data["StartingCards"])
		main_menu.add_child(decks[p_id])


func _start_first_turn() -> void:
	var first_player_id = [p1_id, p2_id].pick_random()
	if is_single_player:
		set_ready_to_play(true)
		var npc_id: int = players[ai_player_id]["NPCID"]
		assert(npc_id >= 0, str("Invalid NPC ID: ", npc_id))
		if "SpecialRules" in NPCDatabase.npc_data[npc_id].keys():
			await NPCDatabase.setup_special_rules(npc_id)
		if first_player_id == p1_id:
			turn_manager.show_start_turn_text()
		else:
			turn_manager.hide_end_turn_button()
			ai_player.ai_turn_manager.start_turn()
	
	else:
		for p_id in players:
			set_ready_to_play.rpc_id(p_id, true)
		turn_manager.hide_end_turn_button.rpc_id(
			opposing_player_id(first_player_id)
		)
		turn_manager.show_start_turn_text.rpc_id(first_player_id)


@rpc("call_local")
func _set_cards_in_hand_and_play() -> void:
	cards_in_hand[p1_id] = []
	cards_in_play[p1_id] = []
	cards_in_hand[p2_id] = []
	cards_in_play[p2_id] = []


@rpc("call_local")
func _create_resources():
	for p_id in players:
		var res := Resources.new(p_id)
		resources[p_id] = res
		battle_map.add_child(res, true)


@rpc("call_local")
func set_ready_to_play(is_ready: bool) -> void:
	is_ready_to_play = is_ready


func _get_current_deck() -> Dictionary:
	if testing:
		return DeckCollection.decks[DeckCollection.deck_ids.PLAYER_TESTING]
	
	var config := ConfigFile.new()
	config.load(collections_path)
	var deck_id: int = config.get_value("deck_data", "current_deck_id")
	return DeckCollection.decks[deck_id]


func cleanup_game() -> void:
	is_ready_to_play = false
	battle_map = null
	victory_spaces = []
	turn_manager = null
	play_spaces = []
	ps_column_row = {}
	zoom_preview = null
	resource_bars = {}
	progress_bars = {}
	resources = {}
	decks = {}
	cards_in_hand = {}
	cards_in_play = {}
	territories = []
	starting_draw = 1
	players = {}

	### SINGLEPLAYER ###
	ai_player = null
	ai_player_id = -1
