extends CardInPlay


class_name ArcaneArrow


func resolve_spell(selected_column: int, selected_row: int) -> bool:
	var selected_card: CardInPlay = (
		GameManager.ps_column_row[selected_column][selected_row].card_in_this_play_space
	)
	selected_card.highlight_card(true)
	selected_card.resolve_damage(3)
	BattleManager.finish_resolve()
	return true


func is_spell_to_play_now() -> bool:
	for c in CardHelper.cards_in_range(
		GameManager.ai_player_id, 2, TargetSelection.target_restrictions.OPPONENT_UNITS
	):
		if c.battle_stats.health <= 3:
			return true
		
	return false


func resolve_spell_for_ai() -> void:
	var targets: Array = []
	for c in CardHelper.cards_in_range(
		GameManager.ai_player_id, 2, TargetSelection.target_restrictions.OPPONENT_UNITS
	):
		if c.battle_stats.health <= 3:
			targets.append(c)
	
	assert(
		len(targets) > 0, 
		str("No targets to select, AI shouldn't have played this spell: ", ingame_name)
	)
	var target: CardInPlay = targets.pick_random()
	target.highlight_card(true)
	await target.resolve_damage(3)
	Events.spell_resolved_for_ai.emit()
	BattleManager.finish_resolve()
