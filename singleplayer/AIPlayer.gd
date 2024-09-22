extends Node

class_name AIPlayer


var ai_turn_manager: AITurnManager
var player_id: int
var moving_cards := false
var turn_finished := false


func play_turn() -> void:
	await play_playable_cards()
	await GameManager.battle_map.get_tree().create_timer(0.5).timeout
	await use_cards_in_play()
	await GameManager.battle_map.get_tree().create_timer(0.5).timeout
	ai_turn_manager.end_turn()


func discard_card() -> void:
	var card: CardInHand
	card = GameManager.cards_in_hand[player_id].picK_random
	card.discard()


func play_playable_cards() -> void:
	var playing_cards := true
	while playing_cards:
		playing_cards = false
		for c in GameManager.cards_in_hand[player_id]:
			if (
				GameManager.resources[player_id].can_pay_costs(c.costs) 
				and c.card_type == Collections.card_types.UNIT
			):
				playing_cards = await play_card(c)
				if playing_cards:
					await GameManager.battle_map.get_tree().create_timer(0.25).timeout


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
		if Collections.play_space_attributes.RESOURCE_SPACE in ps.attributes:
			play_space = ps
	if !play_space:
		play_space = ps_options.pick_random()
	BattleManager.play_unit(card.card_index, player_id, play_space.column, play_space.row)
	BattleManager.remove_card_from_hand(player_id, card.hand_index)
	return true


func use_cards_in_play() -> void:
	var using_actions := true
	while using_actions:
		using_actions = false
		for c in GameManager.cards_in_play[player_id]:
			if !c.exhausted:
				using_actions = await use_card_action(c)
				if using_actions:
					await GameManager.battle_map.get_tree().create_timer(0.25).timeout
					await GameManager.battle_map.get_tree().process_frame


func use_card_action(card: CardInPlay) -> bool:
	if Collections.play_space_attributes.RESOURCE_SPACE in card.current_play_space.attributes:
		if card.current_play_space.conquered_by != player_id:
			card.conquer_space()
			return true
	
	for c in GameManager.cards_in_play[GameManager.p1_id]:
		if !is_instance_valid(c):
			continue
		
		if len(card.spaces_in_range_to_attack_card(c)) > 0:
			await card.move_and_attack(c)
			card.exhaust()
			return true
	
	return await move_to_conquer_space(card)


func move_to_conquer_space(card: CardInPlay) -> bool:
	if len(CardHelper.closest_conquerable_space(player_id, card)) == 0:
		return false
		
	var space_to_move_to: PlaySpace
	space_to_move_to = CardHelper.closest_conquerable_space(player_id, card).pick_random()
	var card_path = card.current_play_space.find_play_space_path(
		space_to_move_to, card.move_through_units
	)
	
	if card_path.path_length == 0:
		return false 
	
	if card_path.path_length <= card.movement:
		await card.move_to_play_space(space_to_move_to.column, space_to_move_to.row)
		card.exhaust()
		return true
	
	var path_to_take: PlaySpacePath = card.current_play_space.path_to_closest_movable_space(
		space_to_move_to, card.battle_stats.movement, card.move_through_units
	)
	await card.move_over_path(path_to_take)
	card.exhaust()
	return true
