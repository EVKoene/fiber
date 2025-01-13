extends Node


func spaces_in_range(range_to_check: int) -> Array:
	var spaces := []
	for c in GameManager.cards_in_play[GameManager.ai_player_id]:
		for ps in c.spaces_in_range(range_to_check):
			if ps not in spaces:
				spaces.append(ps)
	
	return spaces


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
					CardHelper.on_victory_space(card_swap) 
					and !CardHelper.on_victory_space(card)
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


func conquer_space(card: CardInPlay) -> bool:
	var n_conquered_victory_spaces := 0
	for s in GameManager.victory_spaces:
		if !s.conquered_by:
			continue
		
		if s.conquered_by == GameManager.ai_player_id:
			n_conquered_victory_spaces += 1
	if n_conquered_victory_spaces >= MapSettings.n_progress_bars:
		GameManager.ai_player.game_over = true
	
	card.conquer_space()
	
	return true


func attack_adjacent_enemies(card: CardInPlay) -> bool:
	var enemies_in_attack_range := CardHelper.cards_in_range_of_card(
			card, 1, TargetSelection.target_restrictions.OPPONENT_UNITS
		)
	if len(enemies_in_attack_range) > 0:
		await card.attack_card(enemies_in_attack_range.pick_random())
		return true
	
	return false


func areas_with_most_enemy_units(range_to_check: int, max_axis: int, min_axis: int) -> Array:
	var areas := []
	var play_spaces_in_range := spaces_in_range(range_to_check)
	var highest_n_enemies := 0
	for c in range(MapSettings.n_columns - max_axis):
		var area := []
		var is_area_in_range := false
		var n_enemies := 0
		for r in range(MapSettings.n_rows - min_axis):
			var ps: PlaySpace = GameManager.ps_column_row[c][r]
			if ps in play_spaces_in_range:
				is_area_in_range = true
			if (
				ps.card_in_this_play_space 
				and ps.card_in_this_play_space.card_owner_id == GameManager.p1_id
			):
				n_enemies += 1
		if !is_area_in_range:
			continue
		if n_enemies == 0:
			continue
		if n_enemies < highest_n_enemies:
			continue
		if n_enemies == highest_n_enemies:
			areas.append(area)
		if n_enemies > highest_n_enemies:
			areas = [area]
			highest_n_enemies = n_enemies
			
	return areas
