extends Node


func use_card_action(card: CardInPlay) -> bool:
	if should_conquer_space(card):
		return true

	# Checking if any abilities should be used
	if card.is_ability_to_use_now():
		card.resolve_ability_for_ai()
		await Events.card_ability_resolved_for_ai
		if card.exhausted:
			return true

	if Collections.purposes.CONQUER_SPACES in card.purposes:
		if await move_to_conquer_space(card):
			return true
	if Collections.purposes.DEFEND_RESOURCE in card.purposes:
		if Collections.play_space_attributes.VICTORY_SPACE in card.current_play_space.attributes:
			var enemies_in_attack_range: Array = CardHelper.cards_in_range_of_card(
				card, 1, TargetSelection.target_restictions.OPPONENT_UNITS
			)
			if len(enemies_in_attack_range) > 0:
				card.attack_card(enemies_in_attack_range.pick_random())

			return true
		else:
			return await move_to_conquer_space(card)

	# Finding the first card to attack
	for c in GameManager.cards_in_play[GameManager.p1_id]:
		if !is_instance_valid(c):
			continue

		if card.is_space_in_range_of_attack(c.current_play_space):
			card.exhaust()
			card.attack_card(c)
			return true
			
		if len(card.spaces_in_range_to_melee_attack_space(c.current_play_space)) > 0:
			card.exhaust()
			await card.move_and_attack(c)
			return true

	return await move_to_conquer_space(card)


func move_to_conquer_space(card: CardInPlay) -> bool:
	if len(CardHelper.closest_conquerable_space(card.card_owner_id, card)) == 0:
		return false

	var space_to_move_to: PlaySpace
	space_to_move_to = CardHelper.closest_conquerable_space(card.card_owner_id, card).pick_random()
	var card_path = card.current_play_space.find_play_space_path(
		space_to_move_to, card.move_through_units
	)

	if card_path.path_length == 0:
		return await AIHelper.attack_adjacent_enemies(card)

	if card_path.path_length <= card.battle_stats.movement:
		card.move_to_play_space(space_to_move_to.column, space_to_move_to.row)
		card.exhaust()
		await AIHelper.attack_adjacent_enemies(card)
		return true

	var path_to_take: PlaySpacePath = card.current_play_space.path_to_closest_movable_space(
		space_to_move_to, card.battle_stats.movement, card.move_through_units
	)
	await card.move_over_path(path_to_take)
	card.exhaust()
	await AIHelper.attack_adjacent_enemies(card)
	return true


func should_conquer_space(card: CardInPlay) -> bool:
	if (
		Collections.play_space_attributes.VICTORY_SPACE in card.current_play_space.attributes
		and !card.fabrication
	):
		if card.current_play_space.conquered_by != card.card_owner_id:
			return AIHelper.conquer_space(card)
	
	return false


func can_defend_space(card: CardInPlay, ps: PlaySpace) -> bool:
	var expected_attack_value := 0
	for enemy_unit in GameManager.cards_in_play[GameManager.p1_id]:
		if enemy_unit.is_space_in_range_of_attack(ps, true):
			expected_attack_value += enemy_unit.battle_stats.avg_attack
	
	if expected_attack_value < card.battle_stats.health:
		return true
	else:
		return false
