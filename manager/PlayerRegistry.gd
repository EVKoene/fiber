class_name PlayerRegistry
extends Node

### PLAYER ###
var is_player_1 := false
var p1_id: int
var p2_id: int
var players := {}
var is_single_player := true
var player_id: int
var multiplayer_deck := {}


@rpc("any_peer", "call_local")
func add_player(
	player_number: int, p_id: int, player_name: String, p_deck: Dictionary = {}, npc_id: int = -1
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

	if GameManager.is_server and player_number == 2 and !is_single_player:
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

		GameManager.main_menu.show_start_game_button.rpc()


func opposing_player_id(p_id: int) -> int:
	if p_id == p1_id:
		return p2_id
	else:
		return p1_id


func cleanup() -> void:
	is_player_1 = false
	p1_id = 0
	p2_id = 0
	players = {}
	is_single_player = true
	player_id = 0
	multiplayer_deck = {}
