extends CardInPlay


class_name ShockCharge


func resolve_spell(_c_column: int, _c_row) -> bool:
	Events.show_instructions.emit("Choose up to two units to refresh")
	GameManager.battle_map.show_finish_button()
	TargetSelection.making_selection = true
	
	TargetSelection.select_targets(
		2, TargetSelection.target_restrictions.OWN_UNITS, null, false, -1, true
	)
	
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) in [1, 2]:
		
		for c in TargetSelection.selected_targets:
			c.refresh()
		
		BattleSynchronizer.finish_resolve()
		return true
	
	else:
		BattleSynchronizer.finish_resolve()
		return false


func is_spell_to_play_now() -> bool:
	var n_exhausted_cards := 0
	for c in GameManager.cards_in_play[card_owner_id]:
		if c.exhausted:
			n_exhausted_cards += 1
			if n_exhausted_cards == 2:
				return true
		
	return false


func resolve_spell_for_ai() -> void:
	var exhausted_cards := []
	for c in GameManager.cards_in_play[card_owner_id]:
		if c.exhausted:
			exhausted_cards.append(c)
			if len(exhausted_cards) == 2:
				for card in exhausted_cards:
					card.refresh()
		
	assert(false, "AIPlayer shouldn't have played Shock Charge, not enough targets")
