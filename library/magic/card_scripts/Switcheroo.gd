extends CardInPlay


class_name Switcheroo


func resolve_spell(selected_column: int, selected_row: int) -> bool:
	var selected_card: CardInPlay = (
		GameManager.ps_column_row[selected_column][selected_row].card_in_this_play_space
	)
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, selected_card, false, -1, true
	)
	selected_card.select_card(true)
	Events.show_instructions.emit("Choose two cards with the same owner to swap")
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
		var target_card: CardInPlay = TargetSelection.selected_targets[0]
		selected_card.swap_with_card(
			target_card.card_owner_id, target_card.card_in_play_index
		)
		GameManager.resources[card_owner_id].add_resource(Collections.factions.MAGIC, 1)
		TargetSelection.end_selecting()
		return true
	else:
		TargetSelection.end_selecting()
		return false
