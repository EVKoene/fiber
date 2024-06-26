extends Node

# This needs to be a scene instead of just a script because we need to export a number of vars
# so both players can access them. Another option would be to put them in in the BattleMap scene
# for example, but I prefer this for now.

class_name TurnManager


enum turn_stages { CARD_PLAYS, END_TURN, START_TURN }

@export var turn_count := 0
@export var turn_owner_id: int
@export var turn_stage: int
# Turn actions should be disabled whenever we don't want te player to be able to make a move,
# basically whenever we're handling consequences of actions such as playing a card or starting the
# turn
@export var turn_actions_enabled := false
@export var starting_turn_player_id: int


func _ready():
	GameManager.turn_manager = self


@rpc("call_local")
func show_start_turn_text() -> void:
	GameManager.battle_map.show_text("It's your turn!")


@rpc("any_peer", "call_local")
func start_turn(player_id: int) -> void:
	starting_turn_player_id = -1
	turn_stage = turn_stages.START_TURN
	turn_owner_id = player_id
	var player := GameManager.player_from_id(player_id)
	player.resources.refresh()
	for c in GameManager.cards_in_play[player_id]:
		c.refresh()
	show_end_turn_button.rpc_id(player_id)
	turn_actions_enabled = true


@rpc("any_peer", "call_local")
func end_turn(player_id: int) -> void:
	assert(
		GameManager.is_server, 
		str(
			"Turn functions should only be executed by server. Was instead executed by player with 
			player_id ", player_id)
	)
	
	turn_actions_enabled = false
	turn_stage = turn_stages.END_TURN
	hide_end_turn_button.rpc_id(player_id)
	var next_player_id: int = GameManager.opposing_player_id(player_id)
	starting_turn_player_id = next_player_id
	show_start_turn_text.rpc_id(next_player_id)


@rpc("call_local")
func show_end_turn_button() -> void:
	GameManager.battle_map.end_turn_button.show()


@rpc("call_local")
func hide_end_turn_button() -> void:
	GameManager.battle_map.end_turn_button.hide()
