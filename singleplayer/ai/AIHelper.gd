extends Node


func find_cards_with_stat_from_options(
	card_options: Array, stat: int, stat_param: int, stat_target: int
) -> Array:
	var cards: Array = []
	var lowest_stat: int = 0
	
	for c in card_options:
		var card_stat: int
		
		match stat:
			Collections.stats.HEALTH:
				card_stat = c.battle_stats.health
			Collections.stats.MAX_ATTACK:
				card_stat = c.battle_stats.max_attack
			Collections.stats.MIN_ATTACK:
				card_stat = c.battle_stats.min_attack
			Collections.stats.MOVEMENT:
				card_stat = c.battle_stats.movement
			Collections.stats.TOTAL_COST:
				card_stat = c.costs.total()
		
		match stat_param:
			Collections.stat_params.LOWEST:
				if card_stat == lowest_stat:
					cards.append(c)
				elif card_stat < lowest_stat or (card_stat > lowest_stat and len(cards) == 0):
					cards = [c]
					lowest_stat = card_stat

			Collections.stat_params.HIGHEST:
				var highest_stat = 0
				if card_stat == highest_stat:
					cards.append(c)
				elif (
					card_stat > highest_stat 
				):
					cards = [c]
					highest_stat = card_stat

			Collections.stat_params.OVER_VALUE:
				if card_stat > stat_target:
					cards.append(c)

			Collections.stat_params.UNDER_VALUE:
				if card_stat < stat_target:
					cards.append(c)

	return cards


func cards_to_swap_with(card) -> Array:
	# Calculate for each card whether the swap is beneficial for the card with the highest cost.
	# Return the cards with the highest cost and a beneficial swap
	var highest_cost_swap: int = -1
	var swap_cards := []
	for c in GameManager.cards_in_play[card.card_owner_id]:
		var beneficial_swap := false
		var card_costs_minus_c_costs: int = card.costs.total() - c.costs.total()
		if is_wanting_to_swap_with_card(card, c) and is_wanting_to_swap_with_card(c, card):
			beneficial_swap = true
		elif is_wanting_to_swap_with_card(card, c) and card_costs_minus_c_costs > 0:
			beneficial_swap = true
		elif is_wanting_to_swap_with_card(c, card) and card_costs_minus_c_costs < 0:
			beneficial_swap = true
	
		if beneficial_swap and highest_cost_swap == -1:
			highest_cost_swap = max(card.costs.total(), c.costs.total())
			swap_cards = [c]
		elif beneficial_swap and highest_cost_swap < max(card.costs.total(), c.costs.total()):
			highest_cost_swap = max(card.costs.total(), c.costs.total())
			swap_cards = [c]
		elif beneficial_swap and highest_cost_swap == max(card.costs.total(), c.costs.total()):
			swap_cards.append(c)
		

	return swap_cards


func is_wanting_to_swap_with_card(card: CardInPlay, card_swap: CardInPlay) -> bool:
	var want: bool = false
	for p in card.purposes:
		match p:
			Collections.purposes.BUFF_ADJACENT:
				if (
					CardHelper.n_cards_in_adjacent_play_spaces(
						card_swap, TargetSelection.target_restrictions.OWN_UNITS
					) > CardHelper.n_cards_in_adjacent_play_spaces(
						card, TargetSelection.target_restrictions.OWN_UNITS
					)
				):
					want = true
			Collections.purposes.DEBUFF_ADJACENT:
				if (
					CardHelper.n_cards_in_adjacent_play_spaces(
						card_swap, TargetSelection.target_restrictions.OPPONENT_UNITS
					) > CardHelper.n_cards_in_adjacent_play_spaces(
						card, TargetSelection.target_restrictions.OPPONENT_UNITS
					)
				):
					want = true
			Collections.purposes.DEFEND_RESOURCE:
				if (
					CardHelper.on_resource_space(card_swap) 
					and !CardHelper.on_resource_space(card)
				):
					want = true
			Collections.purposes.BATTLE:
				if (
					CardHelper.distance_to_closest_enemy_unit(card_swap) < 
					CardHelper.distance_to_closest_enemy_unit(card)
				):
					want = true
			Collections.purposes.REAR:
				if (
					CardHelper.distance_to_closest_enemy_unit(card_swap) > 
					CardHelper.distance_to_closest_enemy_unit(card)
				):
					want = true
	

	return want
