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
		if GameManager.is_single_player:
			CardManipulation.change_max_attack(card_owner_id, card_in_play_index, 2, -1)
			CardManipulation.change_min_attack(card_owner_id, card_in_play_index, 2, -1)
			CardManipulation.change_health(card_owner_id, card_in_play_index, 2, -1)
		if !GameManager.is_single_player:
			for p_id in GameManager.players:
				CardManipulation.change_max_attack.rpc_id(p_id, card_owner_id, card_in_play_index, 2, -1)
				CardManipulation.change_min_attack.rpc_id(p_id, card_owner_id, card_in_play_index, 2, -1)
				CardManipulation.change_health.rpc_id(p_id, card_owner_id, card_in_play_index, 2, -1)
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
	
	CardManipulation.change_max_attack(card_owner_id, card_in_play_index, 2, -1)
	CardManipulation.change_min_attack(card_owner_id, card_in_play_index, 2, -1)
	CardManipulation.change_health(card_owner_id, card_in_play_index, 2, -1)
	Events.card_ability_resolved_for_ai.emit()
	

func is_ability_to_use_now() -> bool:
	for c in CardHelper.cards_in_range(
		card_owner_id, 1, TargetSelection.target_restrictions.OWN_UNITS
	):
		if c.card_owner_id == card_owner_id and c.cost <= 1:
			return true
	
	return false
