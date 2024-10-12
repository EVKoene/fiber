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
			if GameManager.is_single_player:
				BattleManager.draw_card(card_owner_id)
			
			if !GameManager.is_single_player:
				BattleManager.draw_card.rpc_id(GameManager.p1_id, card_owner_id)
		
		exhaust()
		BattleManager.finish_resolve()
		return true
	
	else:
		BattleManager.finish_resolve()
		return false


func resolve_ability_for_ai() -> void:
	var consume_options = CardHelper.cards_in_range(
		card_owner_id, 1, TargetSelection.target_restrictions.OWN_UNITS
	)
	consume_options = AIHelper.find_cards_with_stat_from_options(
		consume_options, Collections.stats.TOTAL_COST, Collections.stat_params.LOWEST, -1
	)
	
	consume_options.pick_random().destroy_card()
	GameManager.ai_player.discard_cards(1)
	
	for i in range(3):
		GameManager.decks[card_owner_id].draw_card()
	Events.card_ability_resolved_for_ai.emit()
	

func is_ability_to_use_now() -> bool:
	for c in CardHelper.cards_in_range(
		card_owner_id, 1, TargetSelection.target_restrictions.OWN_UNITS
	):
		if c.card_owner_id == card_owner_id and c.cost <= 1:
			return true
	
	return false
