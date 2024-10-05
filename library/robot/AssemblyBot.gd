extends CardInPlay


class_name AssemblyBot


func enter_battle() -> void:
	if card_owner_id == GameManager.player_id and card_owner_id != GameManager.ai_player_id:
		Events.show_instructions.emit("Choose a space to place the robot fabrication")
		GameManager.battle_map.show_finish_button()
		for ps in current_play_space.adjacent_play_spaces():
			ps.highlight_space()
		TargetSelection.select_play_spaces(1, current_play_space.adjacent_play_spaces())

		await TargetSelection.space_selection_finished
		assert(
			len(TargetSelection.selected_spaces) <= 1, str("Expected 1 or 0 selected spaces, received
			", len(TargetSelection.selected_spaces), " selected spaces")
		)
		if len(TargetSelection.selected_spaces) == 1:
			var fab_space: PlaySpace = TargetSelection.selected_spaces[0]
			_assemble_robot(fab_space.column, fab_space.row)

		BattleManager.finish_resolve()
	
	
	if card_owner_id == GameManager.ai_player_id:
		await get_tree().create_timer(0.25).timeout
		for ps in current_play_space.adjacent_play_spaces():
			if !ps.card_in_this_play_space:
				_assemble_robot(ps.column, ps.row)
				break


func _assemble_robot(fab_column: int, fab_row: int) -> void:
	if GameManager.is_single_player:
		BattleManager.create_fabrication(
			card_owner_id, fab_column, fab_row, "Robot", 1, 0, 1, 1, [], 
			"res://library/robot/images/Robot.png", [Collections.factions.ROBOT], {
						Collections.factions.ANIMAL: 0,
						Collections.factions.MAGIC: 0,
						Collections.factions.NATURE: 0,
						Collections.factions.ROBOT: 1,
					}
		)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleManager.create_fabrication.rpc_id(
				p_id, card_owner_id, fab_column, fab_row, "Robot", 1, 0, 1, 1, [], 
				"res://library/robot/images/Robot.png", [Collections.factions.ROBOT], {
							Collections.factions.ANIMAL: 0,
							Collections.factions.MAGIC: 0,
							Collections.factions.NATURE: 0,
							Collections.factions.ROBOT: 1,
						}
			)
