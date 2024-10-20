extends Node

class_name Lobby

var lobby_id: int
### SCENES ###
var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
var overworld_scene: PackedScene = load("res://overworld/areas/StartingArea.tscn")

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
var is_server := false
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


func _ready():
	if !MultiplayerManager.dedicated_server:
		if GameManager.is_server:
			is_player_1 = true
		player_id = GameManager.main_menu.multiplayer.get_unique_id()
	if MultiplayerManager.dedicated_server:
		MultiplayerManager.server_manager.open_lobbys.append(self)


@rpc("any_peer", "call_local")
func add_player(p_id: int, player_name: String, p_deck: Dictionary) -> void:
	var player_number: int
	if len(players) == 0:
		player_number = 1
	elif len(players) == 1:
		player_number = 2
	else:
		assert(false, "Tried to add more than 2 players to lobby")
	
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
	
	if len(players) == 2 and GameManager.is_dedicated_server:
		MultiplayerManager.server_manager.open_lobbys.erase(self)
		start_game.rpc()


@rpc("any_peer", "call_local")
func start_game() -> void:
	GameManager.main_menu.hide_main_menu()
	var b_map = battle_map_scene.instantiate()
	b_map.lobby = self
	GameManager.main_menu.add_child(b_map, true)


func start_single_player_battle(npc_id: int) -> void:
	var npc_data: Dictionary = NPCDatabase.npc_data[npc_id]
	if !GameManager.lobby.players.has(1):
		GameManager.lobby.add_player(
			1, "Player1", GameManager.deck
		)

	GameManager.lobby.add_player(2, npc_data["Name"], npc_data["Deck"])
	start_game()

	ai_player = null
	ai_player_id = -1


func opposing_player_id(p_id: int) -> int:
	if p_id == p1_id:
		return p2_id
	else:
		return p1_id
