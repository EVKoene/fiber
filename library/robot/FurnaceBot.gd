extends CardInPlay


class_name FurnaceBot


func _init() -> void:
	abilities = [{
		"FuncName": "consume_for_fuel",
		"FuncText": "Consume for fuel",
		"AbilityCosts": Costs.new(0, 0, 0, 0),
	}]


func consume_for_fuel() -> bool:
	Events.show_instructions.emit("Choose unit to consume")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, self, false, 1
	)
	
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
		TargetSelection.selected_targets[0].destroy()
		for p_id in GameManager.players:
			CardManipulation.change_max_attack.rpc_id(p_id, card_owner_id, card_in_play_index, 2, -1)
			CardManipulation.change_min_attack.rpc_id(p_id, card_owner_id, card_in_play_index, 2, -1)
			CardManipulation.change_health.rpc_id(p_id, card_owner_id, card_in_play_index, 2, -1)
		TargetSelection.end_selecting()
		return true
	else:
		TargetSelection.end_selecting()
		return false
