extends Node

#TODO: This file desperately needs to be split into several smaller files, but I can't find a
# setup that makes sense.
### SCENES ###
var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
@onready var turn_manager_scene: PackedScene = preload("res://manager/TurnManager.tscn")

### GENERAL ###
var version := "0.0.5"
var testing := false
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
var multiplayer_deck := {}

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
var is_resolving_movement := false
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
var deck_builder: DeckBuilder
@onready var save_path := "user://savedata/"
@onready var collections_path := str(save_path, "collections.ini")

### OVERWORLD ###
var current_scene: Variant
var raycast: PlayerRaycast

@rpc("any_peer", "call_local")
func add_player(
	player_number: int, p_id: int, player_name: String, p_deck: Dictionary, npc_id: int = -1
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


@rpc("any_peer", "call_local")
func start_game(_npc_id: int = -1) -> void:
	main_menu.hide_main_menu()
	var b_map = battle_map_scene.instantiate()
	GameManager.current_scene = b_map
	main_menu.add_child(b_map, true)


func start_single_player_battle(npc_id: int) -> void:
	ai_player = null
	ai_player_id = -1
	var npc_data: Dictionary = NPCDatabase.npc_data[npc_id]
	if !players.has(1):
		add_player(1, 1, "Player1", DeckSetup.deck)
	player_id = 1

	add_player(2, 2, npc_data["Name"], DeckCollection.decks[npc_data["DeckID"]], npc_id)
	start_game(npc_id)


func opposing_player_id(p_id: int) -> int:
	if p_id == p1_id:
		return p2_id
	else:
		return p1_id


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
		call_deferred("_start_first_turn")
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
		if NPCDatabase.npc_data[npc_id]["BossCard"] != -1:
			GameManager.ai_player.boss = BattleSynchronizer.play_boss(
				NPCDatabase.npc_data[npc_id]["BossCard"], 2, 4, 0
			)
			GameManager.ai_player.boss.prepare_next_turn_boss_ability()
		for c in NPCDatabase.npc_data[npc_id]["StartingUnits"]:
			var starting_card: Dictionary = NPCDatabase.npc_data[npc_id]["StartingUnits"][c]
			BattleSynchronizer.play_unit(
				starting_card["CardIndex"], 
				ai_player_id, 
				starting_card["Column"], 
				starting_card["Row"]
			)
		if "SpecialRules" in NPCDatabase.npc_data[npc_id].keys(): #TODO: Special rules can be removed
			for rule in NPCDatabase.npc_data[npc_id]["SpecialRules"]:
				await NPCDatabase.setup_special_rules(rule)
		if first_player_id == p1_id:
			turn_manager.show_start_turn_text()
		else:
			turn_manager.hide_end_turn_button()
			ai_player.ai_turn_manager.start_turn()

	else:
		for p_id in players:
			set_ready_to_play.rpc_id(p_id, true)
		turn_manager.hide_end_turn_button.rpc_id(opposing_player_id(first_player_id))
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
	players = {}

	### SINGLEPLAYER ###
	ai_player = null
	ai_player_id = -1
