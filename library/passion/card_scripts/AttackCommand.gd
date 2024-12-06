extends CardInPlay


class_name AttackCommand

func resolve_spell(c_column: int, c_row: int) -> bool:
	var selected_card: CardInPlay = (
		GameManager.ps_column_row[c_column][c_row].card_in_this_play_space
	)
	Events.show_instructions.emit("Choose a unit to attack")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.ANY_UNITS, selected_card, 
		false, 2, true
	)
	selected_card.select_card(true)
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
	
		var card_to_attack: CardInPlay = TargetSelection.selected_targets[0]
		selected_card.attack_card(card_to_attack)
		
		# finish_resolve will emit target_selection_finished, and because that has already been
		# emitted in this same function we need to wait a frame to avoid errors
		BattleSynchronizer.finish_resolve()
		if Tutorial.next_phase == Tutorial.tutorial_phases.END_TURN:
			Tutorial.continue_tutorial()
		return true
	
	else:
		BattleSynchronizer.finish_resolve()
		return false


func is_spell_to_play_now() -> bool:
	for c in GameManager.cards_in_play[GameManager.ai_player_id]:
		for e in CardHelper.cards_in_range_of_card(
			c, 2, TargetSelection.target_restrictions.OPPONENT_UNITS
		):
			if e.battle_stats.health <= c.battle_stats.max_attack:
				return true
		
	return false


func resolve_spell_for_ai() -> void:
	for c in GameManager.cards_in_play[GameManager.ai_player_id]:
		for e in CardHelper.cards_in_range_of_card(
			c, 2, TargetSelection.target_restrictions.OPPONENT_UNITS
		):
			if e.battle_stats.health <= c.battle_stats.max_attack:
				c.attack_card(e)
				return
	
