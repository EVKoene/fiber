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
		CardManipulation.change_battle_stat(
			Collections.stats.MIN_ATTACK, selected_card.card_owner_id, 
			selected_card.card_in_play_index, 1, -1
		)
		CardManipulation.change_battle_stat(
			Collections.stats.HEALTH, selected_card.card_owner_id, 
			selected_card.card_in_play_index, 1, -1
		)
		
		exhaust()
		TargetSelection.making_selection = false
		
		BattleManager.finish_resolve()
		return true

	else:
		BattleManager.finish_resolve()
		return false
