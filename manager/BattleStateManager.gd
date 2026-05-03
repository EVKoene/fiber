class_name BattleStateManager
extends Node

var battle_map: Node
var turn_manager: TurnManager
var zoom_preview: ZoomPreview
var resources := {}
var resource_bars := {}
var progress_bars := {}
var decks := {}
var cards_in_hand := {}
var cards_in_play := {}
var play_spaces: Array[PlaySpace] = []
var ps_column_row := {}
var territories := []
var victory_spaces: Array[PlaySpace] = []
var current_play_space_selector: PlaySpaceSelector
var is_ready_to_play := false
var is_resolving_movement := false


@rpc("any_peer")
func setup_game() -> void:
	_set_cards_in_hand_and_play.rpc()
	if PlayerRegistry.is_single_player:
		_create_resources()
	elif !PlayerRegistry.is_single_player:
		for i in [1, PlayerRegistry.p1_id, PlayerRegistry.p2_id]:
			_create_resources.rpc_id(i)
	_add_turn_managers()
	_add_decks()
	if !battle_map.is_tutorial:
		call_deferred("_start_first_turn")
	else:
		Tutorial.start_tutorial()


func _add_turn_managers() -> void:
	var t_manager = GameManager.turn_manager_scene.instantiate()
	GameManager.main_menu.add_child(t_manager, true)


func _add_decks() -> void:
	for p_id in PlayerRegistry.players:
		var deck_data: Dictionary = PlayerRegistry.players[p_id]["Deck"]
		decks[p_id] = Deck.new(p_id, deck_data["Cards"], deck_data["StartingCards"])
		GameManager.main_menu.add_child(decks[p_id])


func _start_first_turn() -> void:
	var first_player_id = [PlayerRegistry.p1_id, PlayerRegistry.p2_id].pick_random()
	if PlayerRegistry.is_single_player:
		set_ready_to_play(true)
		var npc_id: int = PlayerRegistry.players[GameManager.ai_player_id]["NPCID"]
		assert(npc_id >= 0, str("Invalid NPC ID: ", npc_id))
		if NPCDatabase.npc_data[npc_id]["BossCard"] != -1:
			GameManager.ai_player.boss = BattleSynchronizer.play_boss(
				NPCDatabase.npc_data[npc_id]["BossCard"], 2, 4, 0
			)
			GameManager.ai_player.boss.prepare_next_turn_boss_ability()
		elif NPCDatabase.npc_data[npc_id]["NormalOpponent"] != null:
			var opponent_script = NPCDatabase.npc_data[npc_id]["NormalOpponent"]
			GameManager.ai_player.normal_opponent = opponent_script.new()
			GameManager.ai_player.normal_opponent.prepare_next_turn_ability()
		for c in NPCDatabase.npc_data[npc_id]["StartingUnits"]:
			var starting_card: Dictionary = NPCDatabase.npc_data[npc_id]["StartingUnits"][c]
			BattleSynchronizer.play_unit(
				starting_card["CardIndex"],
				GameManager.ai_player_id,
				starting_card["Column"],
				starting_card["Row"]
			)
		if "SpecialRules" in NPCDatabase.npc_data[npc_id].keys():
			for rule in NPCDatabase.npc_data[npc_id]["SpecialRules"]:
				await NPCDatabase.setup_special_rules(rule)
		if first_player_id == PlayerRegistry.p1_id:
			turn_manager.show_start_turn_text()
		else:
			turn_manager.hide_end_turn_button()
			GameManager.ai_player.ai_turn_manager.start_turn()

	else:
		for p_id in PlayerRegistry.players:
			set_ready_to_play.rpc_id(p_id, true)
		turn_manager.hide_end_turn_button.rpc_id(PlayerRegistry.opposing_player_id(first_player_id))
		turn_manager.show_start_turn_text.rpc_id(first_player_id)


@rpc("call_local")
func _set_cards_in_hand_and_play() -> void:
	cards_in_hand[PlayerRegistry.p1_id] = []
	cards_in_play[PlayerRegistry.p1_id] = []
	cards_in_hand[PlayerRegistry.p2_id] = []
	cards_in_play[PlayerRegistry.p2_id] = []


@rpc("call_local")
func _create_resources():
	for p_id in PlayerRegistry.players:
		var res := Resources.new(p_id)
		resources[p_id] = res
		battle_map.add_child(res, true)


@rpc("call_local")
func set_ready_to_play(is_ready: bool) -> void:
	is_ready_to_play = is_ready


func finish_with_victory() -> void:
	GameManager.ai_player.game_over = true
	battle_map.show_text("You win!")
	await battle_map.text_dismissed

	var battle_rewards := PlayerManager.get_battle_reward()
	if len(battle_rewards) == 0:
		battle_map.show_text("No battle rewards this time...")
		await battle_map.text_dismissed
	else:
		var battle_rewards_string: String
		for c in battle_rewards:
			PlayerManager.add_card_to_collection(c)
			if len(battle_rewards_string) == 0:
				battle_rewards_string = CardDatabase.cards_info[c]["InGameName"]
			else:
				battle_rewards_string += str(", ", CardDatabase.cards_info[c]["InGameName"])
		battle_map.show_text(str("Congratulations! You receive ", battle_rewards_string))
		await battle_map.text_dismissed

	OverworldManager.defeat_npc(PlayerRegistry.players[GameManager.ai_player_id]["NPCID"])
	TransitionScene.transition_to_main_menu()


func finish_with_defeat() -> void:
	if PlayerRegistry.is_single_player:
		GameManager.ai_player.game_over = true

	battle_map.show_text("You lose!")
	await battle_map.text_dismissed


func cleanup() -> void:
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
