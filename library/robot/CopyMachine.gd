extends CardInPlay


class_name CopyMachine


func _init():
	abilities = [{
		"FuncName": "copy_unit",
		"FuncText": "Copy unit",
		"AbilityCosts": Costs.new(0, 0, 0, 3)
	}]


func copy_unit() -> bool:
	var is_ps_for_copy_available := false
	var ps_to_put_copy := []
	
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_space:
			ps_to_put_copy.append(ps)
		elif ps.card_in_this_play_space.card_owner_id == card_owner_id:
			is_ps_for_copy_available = true
	
	if !is_ps_for_copy_available:
		GameManager.battle_map.show_instructions("No adjacent units to copy")
		await get_tree().create_timer(2).timeout
		GameManager.battle_map.hide_instructions()
		return false
	
	if len(ps_to_put_copy) == 0:
		GameManager.battle_map.show_instructions("No adjacent space to put fabrication")
		await get_tree().create_timer(2).timeout
		GameManager.battle_map.hide_instructions()
		return false
	
	
	Events.show_instructions.emit("Pick an adjacent unit to copy")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, self, false, 1
	)
	
	await TargetSelection.target_selection_finished
	
	if len(TargetSelection.selected_targets) == 0:
		TargetSelection.end_selecting()
		return false
	
	if len(TargetSelection.selected_targets) == 1 and len(ps_to_put_copy) == 1:
		TargetSelection.selected_spaces = [ps_to_put_copy[0]]
	
	if len(TargetSelection.selected_targets) == 1 and len(ps_to_put_copy) > 1:
		Events.show_instructions.emit("Pick a space in range 1 to create the fabrication")
		for ps in current_play_space.adjacent_play_spaces():
			if !ps.card_in_this_play_space:
				ps.highlight_space()
		TargetSelection.select_play_spaces(1, ps_to_put_copy)
		await TargetSelection.space_selection_finished

	if len(TargetSelection.selected_targets) == 1 and len(TargetSelection.selected_spaces) == 1:
		var card_to_copy = TargetSelection.selected_targets[0]
		var space_to_put_copy = TargetSelection.selected_spaces[0]
		create_copy(card_to_copy, space_to_put_copy)

		exhaust()
	
	TargetSelection.end_selecting()
	return true


func create_copy(card_to_copy: CardInPlay, ps: PlaySpace) -> void:
	if card_to_copy.fabrication:
		for p_id in [GameManager.p1_id, GameManager.p2_id]:
			BattleManager.create_fabrication.rpc_id(
				p_id, card_owner_id, ps.column, ps.row, 
				card_to_copy.ingame_name, card_to_copy.max_attack, card_to_copy.min_attack, 
				card_to_copy.health, card_to_copy.movement, card_to_copy.triggered_funcs, 
				card_to_copy.img_path, card_to_copy.factions, card_to_copy.costs.get_costs()
			)
	
	if !card_to_copy.fabrication:
		for p_id in [GameManager.p1_id, GameManager.p2_id]:
			BattleManager.play_unit.rpc_id(
				p_id, card_to_copy.card_index, card_to_copy.card_owner_id, ps.column, ps.row
			)
	
	GameManager.cards_in_play[card_owner_id][-1].call_deferred("exhaust")
