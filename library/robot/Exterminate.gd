extends CardInPlay


class_name Exterminate


func resolve_spell(c_column: int, c_row: int) -> bool:
	var selected_card: CardInPlay = (
		GameManager.ps_column_row[c_column][c_row].card_in_this_play_space
	)
	Events.show_instructions.emit("Choose a unit to destroy")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.ANY_UNITS, selected_card, 
		false, 1, true
	)
	selected_card.select_card(true)
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
		BattleManager.ask_resolve_spell_agreement()
		await Events.resolve_spell_button_pressed
	
		var card_to_destroy: CardInPlay = TargetSelection.selected_targets[0]
		selected_card.destroy()
		card_to_destroy.destroy()
		TargetSelection.end_selecting()
		return true
	else:
		TargetSelection.end_selecting()
		return false
