extends Node


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
