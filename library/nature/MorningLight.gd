extends CardInPlay


class_name MorningLight


func resolve_spell(selected_column: int, selected_row: int) -> bool:
	var selected_card: CardInPlay = (
		GameManager.ps_column_row[selected_column][selected_row].card_in_this_play_space
	)
	selected_card.highlight_card(true)
	CardManipulation.change_battle_stat(
		Collections.stats.HEALTH, card_owner_id, card_in_play_index, 2, -1
	)
	CardManipulation.change_battle_stat(
		Collections.stats.MOVEMENT, card_owner_id, card_in_play_index, 1, -1
	)
	
	BattleManager.finish_resolve()
	return true


func is_spell_to_play_now() -> bool:
	for c in GameManager.cards_in_play[GameManager.ai_player_id]:
		if c.costs.total() >= 3:
			return true
	
	return false


func resolve_spell_for_ai() -> void:
	var potential_targets: Array = AIHelper.find_cards_with_stat_from_options(
		GameManager.cards_in_play[card_owner_id], Collections.stats.TOTAL_COST, 
		Collections.stat_params.HIGHEST, -1
	)
	
	assert(
		len(potential_targets) > 0, 
		str("No targets to select, AI shouldn't have played this spell: ", ingame_name)
	)
	var target: CardInPlay = potential_targets.pick_random()
	resolve_spell(target.column, target.row)
	Events.spell_resolved_for_ai.emit()
	BattleManager.finish_resolve()
