extends Node

# This needs to be a scene instead of just a script because we need to export a number of vars
# so both players can access them. Another option would be to put them in in the BattleMap scene
# for example, but I prefer this for now.

class_name TurnManager


enum turn_stages { CARD_PLAYS, END_TURN, START_TURN }

var turn_count := 0
@export var turn_owner_id: int
@export var turn_stage: int
# Turn actions should be disabled whenever we don't want te player to be able to make a move,
# basically whenever we're handling consequences of actions such as playing a card or starting the
# turn
var turn_actions_enabled := false

var can_start_turn := false
var gold_gained := 0
var resource_increases_turns := [1, 2, 4, 7]


func _ready():
	GameManager.turn_manager = self


@rpc("call_local")
func show_start_turn_text() -> void:
	GameManager.battle_map.show_text("It's your turn!")
	can_start_turn = true


@rpc("any_peer", "call_local")
func start_turn(player_id: int) -> void:
	assert(GameManager.is_server, "Start turn func should only be called by server")
	turn_count += 1
	if turn_count in resource_increases_turns:
		gold_gained += 1
	
	if resource_increases_turns.max() > turn_count:
		for t in resource_increases_turns:
			if t > turn_count:
				if !GameManager.is_single_player:
					for p_id in GameManager.players:
						GameManager.battle_map.update_gold_container_text.rpc_id(
							p_id, gold_gained, t - turn_count
						)
				if GameManager.is_single_player:
					GameManager.battle_map.update_gold_container_text(gold_gained, t - turn_count)
				break
	else:
		if !GameManager.is_single_player:
			for p_id in GameManager.players:
				GameManager.battle_map.update_gold_container_text.rpc_id(
					p_id, gold_gained, -1
				)
		if GameManager.is_single_player:
			GameManager.battle_map.update_gold_container_text(gold_gained, -1)
	
	turn_stage = turn_stages.START_TURN
	turn_owner_id = player_id
	if GameManager.is_single_player:
		GameManager.resources[player_id].refresh(gold_gained)
		update_modifiers()
	
	elif !GameManager.is_single_player:
		GameManager.resources[player_id].refresh.rpc_id(player_id, gold_gained)
		for p_id in [GameManager.p1_id, GameManager.p2_id]:
			# NOTE that we update modifiers before calling triggered funcs. This choice has been
			# made early in development and can be changed if it opens potential interesting 
			# interactions
			update_modifiers.rpc_id(p_id)
	
	if GameManager.is_single_player:
		BattleSynchronizer.refresh_all_units(player_id)
		await call_start_turn_triggered_funcs()
	if !GameManager.is_single_player:
		BattleSynchronizer.refresh_all_units.rpc_id(GameManager.p1_id, player_id)
		call_start_turn_triggered_funcs.rpc_id(GameManager.p1_id)
	
	if turn_count >= 2:
		if player_id == GameManager.ai_player_id:
			GameManager.ai_player.draw_start_of_turn_card()
		else:
			GameManager.decks[player_id].pick_card_option()
	
	if turn_owner_id == GameManager.p1_id and GameManager.is_single_player:
		show_end_turn_button()
	elif turn_owner_id == GameManager.ai_player_id:
		GameManager.ai_player.play_turn()
	elif !GameManager.is_single_player:
		show_end_turn_button.rpc_id(player_id)
	set_turn_actions_enabled(true)


@rpc("call_local")
func update_modifiers() -> void:
	for p in GameManager.players:
		for c in GameManager.cards_in_play[p]:
			c.battle_stats.update_modifiers()


@rpc("any_peer", "call_local")
func end_turn(player_id: int) -> void:
	assert(
		GameManager.is_server, 
		str(
			"Turn functions should only be executed by server. Was instead executed by player with 
			player_id ", player_id)
	)
	
	GameManager.turn_manager.set_turn_actions_enabled(false)
	
	turn_stage = turn_stages.END_TURN
	hide_end_turn_button.rpc_id(player_id)
	if GameManager.is_single_player:
		GameManager.ai_player.ai_turn_manager.start_turn()
	else:
		var next_player_id: int = GameManager.opposing_player_id(player_id)
		show_start_turn_text.rpc_id(next_player_id)


@rpc("call_local")
func show_end_turn_button() -> void:
	GameManager.battle_map.end_turn_button_container.show()


@rpc("call_local")
func hide_end_turn_button() -> void:
	GameManager.battle_map.end_turn_button_container.hide()


func set_turn_actions_enabled(is_enabled: bool) -> void:
	if GameManager.is_single_player:
		turn_actions_enabled = is_enabled
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			set_turn_actions_enabled_mp.rpc_id(p_id, is_enabled)


@rpc("any_peer", "call_local")
func set_turn_actions_enabled_mp(is_enabled: bool) -> void:
	turn_actions_enabled = is_enabled


@rpc("any_peer", "call_local")
func call_start_turn_triggered_funcs() -> void:
	for p_id in GameManager.players:
		for c in GameManager.cards_in_play[p_id]:
			await c.call_triggered_funcs(Collections.triggers.TURN_STARTED, c)
