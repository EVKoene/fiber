extends CardInPlay


class_name WizardScout


func _init():
	abilities = [
		{
			"FuncName": "swap",
			"FuncText": "Swap",
			"AbilityCosts": Costs.new(0, 0, 0, 0),
		},
	]


func swap() -> bool:
	select_card(true)
	Events.show_instructions.emit("Choose a card to swap with")
	Events.show_finish_button.emit()
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, self, false, -1, true
	)
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
		swap_with_card(
			TargetSelection.selected_targets[0].card_owner_id,
			TargetSelection.selected_targets[0].card_in_play_index
		)
		exhaust()
		TargetSelection.end_selecting()
		return true
	else:
		TargetSelection.end_selecting()
		return false
