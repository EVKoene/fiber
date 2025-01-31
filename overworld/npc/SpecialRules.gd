extends Node


var add_1_health_eot := false
var create_robot_fabrication := false
var imagination_spells_1_cheaper := false


func add_stat(stat: int, value: int) -> void:
	GameManager.battle_map.show_text(
		str(
			"This is a boss battle! All enemy units will have ", value, "extra ", 
			str(Collections.stat_names[stat])
		)
	)
	for ps in GameManager.play_spaces:
		ps.stat_modifier[GameManager.ai_player_id][Collections.stats.MAX_ATTACK] += 1
	GameManager.battle_map.awaiting_input = true
	await Events.instruction_input_received


func add_1_health_end_of_turn() -> void:
	GameManager.battle_map.show_text(
		str(
			"This is a boss battle! At the end of the turn, your opponent will add 1 health to a 
			random unit."
		)
	)
	
	add_1_health_eot = true
	GameManager.battle_map.awaiting_input = true
	await Events.instruction_input_received


func create_robot_fabrication_end_of_turn() -> void:
	GameManager.battle_map.show_text(
		str(
			"This is a boss battle! At the end of the turn, your opponent will create a robot 
			fabrication in a random space in their territory."
		)
	)
	
	create_robot_fabrication = true
	GameManager.battle_map.awaiting_input = true
	await Events.instruction_input_received


func add_1_health_to_random_unit() -> void:
	var card: CardInPlay = GameManager.cards_in_play[GameManager.ai_player_id].pick_random()
	CardManipulation.change_battle_stat(
		Collections.stats.HEALTH, card.card_owner_id, card.card_in_play_index, 1, -1
	)


func create_robot_fabrication_in_territory():
	var space_options := []
	for ps in GameManager.play_spaces:
		if (
			ps.territory 
			and ps.territory.owner_id == GameManager.ai_player_id 
			and !ps.card_in_this_play_space
		):
			space_options.append(ps)
	if len(space_options) == 0:
		return
	
	var space: PlaySpace = space_options.pick_random()
	var robot = await BattleSynchronizer.create_fabrication(
		GameManager.ai_player_id, space.column, space.row, "Robot", 1, 0, 1, 1, [], 
		"res://assets/card_images/logic/Robot.png", [Collections.fibers.LOGIC], {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 1,
		}
	)
	robot.exhaust()


func make_imagination_spells_1_cheaper() -> void:
	GameManager.battle_map.show_text(
		str(
			"This is a boss battle! All your opponents spells will cost 1 {I} less!", 
		)
	)
	
	imagination_spells_1_cheaper = true
	for c in GameManager.cards_in_hand[GameManager.ai_player_id]:
		if c.costs.imagination  >= 1 and c.card_type == Collections.card_types.SPELL:
			c.costs.change_cost(Collections.fibers.IMAGINATION, -1)
			
	GameManager.battle_map.awaiting_input = true
	await Events.instruction_input_received


func call_triggered_rules(trigger: int, triggering_card: Card) -> void:
	match trigger:
		Collections.triggers.TURN_ENDED:
			if add_1_health_eot:
				add_1_health_to_random_unit()
			if create_robot_fabrication:
				create_robot_fabrication_in_territory()
		Collections.triggers.CARD_ADDED_TO_HAND:
			if imagination_spells_1_cheaper:
				if (
					triggering_card.costs.imagination >= 1 
					and triggering_card.card_type == Collections.card_types.SPELL
				):
					triggering_card.costs.change_cost(Collections.fibers.IMAGINATION, -1)
