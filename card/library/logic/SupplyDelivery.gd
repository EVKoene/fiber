extends CardInPlay


class_name SupplyDelivery


func resolve_spell() -> bool:
	for i in range(3):
		var space_options := []
		for ps in GameManager.play_spaces:
			if (
				ps.territory 
				and ps.territory.owner_id == card_owner_id 
				and !ps.card_in_this_play_space
			):
				space_options.append(ps)
		
		if len(space_options) == 0:
			break
		
		Events.show_instructions.emit("Choose a space to place the Battle Bot fabrication")
		GameManager.battle_map.show_finish_button()
		for ps in space_options:
			ps.highlight_space()
		TargetSelection.select_play_spaces(1, space_options)

		await TargetSelection.space_selection_finished
		assert(
			len(TargetSelection.selected_spaces) <= 1, str("Expected 1 or 0 selected spaces, received
			", len(TargetSelection.selected_spaces), " selected spaces")
		)
		if len(TargetSelection.selected_spaces) == 1:
			var fab_space: PlaySpace = TargetSelection.selected_spaces[0]
			_assemble_battle_bot(fab_space.column, fab_space.row)
		
		await GameManager.battle_map.get_tree().create_timer(0.25).timeout
	
	BattleSynchronizer.finish_resolve()
	
	return true

func _assemble_battle_bot(fab_column: int, fab_row: int) -> void:
	if GameManager.is_single_player:
		BattleSynchronizer.create_fabrication(
			card_owner_id, fab_column, fab_row, "Battle Bot", 3, 3, 3, 1, [], 
			"res://assets/card_images/logic/SupplyDelivery.png", [Collections.fibers.LOGIC],
			 {
				Collections.fibers.PASSION: 0,
				Collections.fibers.IMAGINATION: 0,
				Collections.fibers.GROWTH: 0,
				Collections.fibers.LOGIC: 3,
			}
		)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleSynchronizer.create_fabrication.rpc_id(
				p_id, card_owner_id, fab_column, fab_row, "Robot", 3, 3, 3, 1, [], 
				"res://assets/card_images/logic/SupplyDelivery.png", 
				[Collections.fibers.LOGIC], {
					Collections.fibers.PASSION: 0,
					Collections.fibers.IMAGINATION: 0,
					Collections.fibers.GROWTH: 0,
					Collections.fibers.LOGIC: 3,
				}
			)


func is_spell_to_play_now() -> bool:
	for ps in GameManager.play_spaces:
		if ps.territory and ps.territory.owner_id == card_owner_id and !ps.card_in_this_play_space:
			return true
	
	return false


func resolve_spell_for_ai() -> void:
	var space_options := []
	for ps in GameManager.play_spaces:
		if ps.territory and ps.territory.owner_id == card_owner_id and !ps.card_in_this_play_space:
			space_options.append(ps)
	var spaces_to_pick := []
	if len(space_options) <= 3:
		spaces_to_pick = space_options
	else:
		for i in range(3):
			var space: PlaySpace = space_options.pick_random()
			spaces_to_pick.append(space)
			space_options.erase(space)
	
	for ps in spaces_to_pick:
		await GameManager.battle_map.get_tree().create_timer(0.25).timeout
		_assemble_battle_bot(ps.column, ps.row)
	Events.spell_resolved_for_ai.emit()
	BattleSynchronizer.finish_resolve()
