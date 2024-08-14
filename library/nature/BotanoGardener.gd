extends CardInPlay

class_name BotanoGardener


func _init():
	abilities = [{
		"FuncName": "grow_unit",
		"FuncText": "Grow",
		"AbilityCosts": Costs.new(0, 0, 0, 0)
	}]


func grow_unit() -> bool:
	Events.show_instructions.emit("Choose a unit to give +1/+1")
	GameManager.battle_map.show_finish_button()
	select_card(true)
	
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, self, false, 1, true
	)
	await TargetSelection.target_selection_finished
	
	if len(TargetSelection.selected_targets) == 1:
		var selected_card: CardInPlay = TargetSelection.selected_targets[0]
		for p_id in GameManager.players:
			MPCardManipulation.change_max_attack.rpc_id(
				p_id, selected_card.card_owner_id, selected_card.card_in_play_index, 1, -1
			)
			MPCardManipulation.change_health.rpc_id(
				p_id, selected_card.card_owner_id, selected_card.card_in_play_index, 1, -1
			)
		exhaust()
		TargetSelection.making_selection = false
		TargetSelection.end_selecting()
		return true

	else:
		TargetSelection.end_selecting()
		Events.hide_instructions.emit()
		return false
