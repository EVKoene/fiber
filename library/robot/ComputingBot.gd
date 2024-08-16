extends CardInPlay


class_name ComputingBot


func _init():
	abilities = [{
		"FuncName": "consume_for_cards",
		"FuncText": "Consume for cards",
		"AbilityCosts": Costs.new(0, 0, 0, 1)
	}]


func consume_for_cards() -> bool:
	Events.show_instructions.emit("Choose unit to consume")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, self, false, 1
	)
	
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
		TargetSelection.selected_targets[0].destroy()
		await TargetSelection.select_card_to_discard()
		for i in range(3):
			MPManager.draw_card.rpc_id(GameManager.p1_id, card_owner_id)
		
		exhaust()
		TargetSelection.end_selecting()
		return true
	
	else:
		TargetSelection.end_selecting()
		return false
