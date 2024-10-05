extends CardInPlay


class_name MarcellaWhoNurturesGrowth


func _init():
	abilities = [
		{
			"FuncName": "nurture",
			"FuncText": "Nurture",
			"AbilityCosts": Costs.new(0, 0, 2, 0),
		},
	]


func nurture() -> bool:
	if GameManager.is_single_player:
		BattleManager.draw_card(card_owner_id)
	if !GameManager.is_single_player:
		BattleManager.draw_card.rpc_id(GameManager.p1_id, card_owner_id)
	
	Events.show_instructions.emit("Choose a unit to give +1/+1")
	GameManager.battle_map.show_finish_button()
	select_card(true)
	
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, self, false, 1, true
	)
	await TargetSelection.target_selection_finished
	
	if len(TargetSelection.selected_targets) == 1:
		var selected_card: CardInPlay = TargetSelection.selected_targets[0]
		if GameManager.is_single_player:
			CardManipulation.change_max_attack(
				selected_card.card_owner_id, selected_card.card_in_play_index, 1, -1
			)
			CardManipulation.change_health(
				selected_card.card_owner_id, selected_card.card_in_play_index, 1, -1
			)
			
		if !GameManager.is_single_player:
			for p_id in GameManager.players:
				CardManipulation.change_max_attack.rpc_id(
					p_id, selected_card.card_owner_id, selected_card.card_in_play_index, 1, -1
				)
				CardManipulation.change_health.rpc_id(
					p_id, selected_card.card_owner_id, selected_card.card_in_play_index, 1, -1
				)
		
		exhaust()
		BattleManager.finish_resolve()
		return true

	else:
		exhaust()
		BattleManager.finish_resolve()
		return false
