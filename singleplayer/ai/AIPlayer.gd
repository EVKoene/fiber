extends Node

class_name AIPlayer

@onready var card_resolve_scene := load("res://card/card_classes/CardResolve.tscn")
var ai_turn_manager: AITurnManager
var ai_turns := 0
var player_id: int
var moving_cards := false
var turn_finished := false
var game_over := false
var boss: CardInPlay


func play_turn() -> void:
	use_boss_ability()
	boss.prepare_next_turn_boss_ability()
	await play_playable_cards()
	await GameManager.battle_map.get_tree().create_timer(0.25).timeout
	await use_cards_in_play()
	await GameManager.battle_map.get_tree().create_timer(0.5).timeout
	# If the AI wins by conquering victory spaces, the battle map will be removed and they won't
	# be able to end the turn anymore
	if is_instance_valid(GameManager.battle_map) and !game_over:
		ai_turn_manager.end_turn()


func use_boss_ability() -> void:
	var boss_ability: String = boss.call(boss.next_boss_ability["Func"])
	GameManager.battle_map.show_text(boss_ability)
	
func draw_start_of_turn_card() -> void:
	if !NPCDatabase.npc_data[GameManager.players[GameManager.ai_player_id]["NPCID"]]["PlayCards"]:
		return
	
	if !GameManager.players[player_id]["Deck"].has("AIDrawOrder"):
		BattleSynchronizer.draw_card(player_id)
		return
	
	if ai_turns > len(GameManager.players[player_id]["Deck"]["AIDrawOrder"]):
		BattleSynchronizer.draw_card(player_id)
		return
	
	BattleSynchronizer.create_hand_card(
		player_id, GameManager.players[player_id]["Deck"]["AIDrawOrder"][ai_turns - 1]
	)


func discard_card() -> void:
	var card: CardInHand
	card = GameManager.cards_in_hand[player_id].pick_random()
	card.discard()


func play_playable_cards() -> void:
	var playing_cards := true
	while playing_cards:
		playing_cards = false
		for c in GameManager.cards_in_hand[player_id]:
			if !GameManager.resources[player_id].can_pay_costs(c.costs):
				continue
			if c.card_type == Collections.card_types.UNIT:
				playing_cards = await play_card(c)
				if playing_cards:
					await GameManager.battle_map.get_tree().create_timer(0.25).timeout
			elif c.card_type == Collections.card_types.SPELL:
				var spell: Card = CardDatabase.get_card_class(c.card_index).new()
				spell.card_owner_id = player_id
				var card_info = CardDatabase.cards_info[c.card_index]
				spell.costs = Costs.new(
					card_info["Costs"][Collections.fibers.PASSION],
					card_info["Costs"][Collections.fibers.IMAGINATION],
					card_info["Costs"][Collections.fibers.GROWTH],
					card_info["Costs"][Collections.fibers.LOGIC],
					spell
				)
				playing_cards = await spell.is_spell_to_play_now()
				if playing_cards:
					BattleSynchronizer.lock_zoom_preview_hand(c.card_owner_id, c.hand_index)
					resolve_spell_for_ai(c)
					GameManager.resources[player_id].pay_costs(c.costs)
					await Events.spell_resolved_for_ai


func play_card(card: CardInHand) -> bool:
	await GameManager.battle_map.get_tree().create_timer(0.5).timeout
	var ps_options := []
	for ps in GameManager.play_spaces:
		if !ps.territory:
			continue
		if !ps.card_in_this_play_space and ps.territory.owner_id == player_id:
			ps_options.append(ps)

	if len(ps_options) == 0:
		return false

	var play_space: PlaySpace
	for ps in ps_options:
		if Collections.play_space_attributes.VICTORY_SPACE in ps.attributes:
			play_space = ps
	if !play_space:
		play_space = ps_options.pick_random()
	BattleSynchronizer.play_unit(card.card_index, player_id, play_space.column, play_space.row)
	if len(card.fibers) == 1:
		GameManager.resources[player_id].add_resource(card.fibers[0], 1)
	GameManager.resources[player_id].pay_costs(card.costs)
	BattleSynchronizer.remove_card_from_hand(player_id, card.hand_index)
	return true


func use_cards_in_play() -> void:
	var using_actions := true
	while using_actions:
		using_actions = false
		for c in GameManager.cards_in_play[player_id]:
			if !c.exhausted and !game_over:
				using_actions = await CardActionDecider.use_card_action(c)
				if using_actions and !game_over:
					await GameManager.battle_map.get_tree().process_frame


func discard_cards(n: int) -> void:
	var discarded_cards: int = 0
	while discarded_cards < n and len(GameManager.cards_in_hand[player_id]) > 0:
		(
			AIHelper
			. find_cards_with_stat_from_options(
				GameManager.cards_in_hand[player_id],
				Collections.stats.TOTAL_COST,
				Collections.stat_params.LOWEST,
				-1
			)
			. pick_random()
			. discard_card()
		)


func resolve_spell_for_ai(spell: CardInHand) -> void:
	var card_resolve = GameManager.battle_map.card_resolve_scene.instantiate()
	card_resolve.ai_player = true
	card_resolve.card_index = spell.card_index
	card_resolve.card_owner_id = player_id
	card_resolve.column = -1
	card_resolve.row = -1
	card_resolve.card_owner_id = player_id
	card_resolve.card_in_hand_index = spell.hand_index
	card_resolve.size = MapSettings.total_screen
	GameManager.battle_map.add_child(card_resolve)
	BattleSynchronizer.remove_card_from_hand(player_id, spell.hand_index)


func play_to_closest_available_space(card_index: int, column: int, row: int) -> bool:
	var play_space: PlaySpace = GameManager.ps_column_row[column][row]
	if !play_space.card_in_this_play_space:
		BattleSynchronizer.play_unit(card_index, player_id, column, row)
		return true
		
	var closest_ps: PlaySpace
	var smallest_distance := 0
	for ps in GameManager.play_spaces:
		var distance: int = play_space.distance_to_play_space(ps, true)
		if distance > 0 and distance < smallest_distance:
			smallest_distance = distance
			closest_ps = ps
	
	if smallest_distance > 0:
		BattleSynchronizer.play_unit(card_index, player_id, closest_ps.column, closest_ps.row)
		return true
	
	return false
