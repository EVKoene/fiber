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
		MPManager.ask_resolve_spell_agreement()
		await Events.resolve_spell_button_pressed
		
		for c in TargetSelection.selected_targets:
			c.refresh()
		
		TargetSelection.end_selecting()
		return true
	
	else:
		TargetSelection.end_selecting()
		return false
