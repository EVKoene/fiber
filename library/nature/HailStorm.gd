extends CardInPlay


class_name HailStorm

func resolve_spell(_selected_column: int, _selected_row: int) -> bool:
	TargetSelection.can_drag_to_select = true
	TargetSelection.n_highest_axis_to_select = 3
	TargetSelection.n_lowest_axis_to_select = 3
	TargetSelection.drag_selection_range = 1
	Events.show_instructions.emit("Choose a 3x3 area in range 1 of one of your units")
	GameManager.battle_map.show_finish_button()
	TargetSelection.making_selection = true
	GameManager.turn_manager.turn_actions_enabled = false
	
	await TargetSelection.space_selection_finished
	
	if len(TargetSelection.selected_spaces) >= 1:
		for ps in TargetSelection.selected_spaces:
			if GameManager.is_single_player:
				BattleAnimation.play_hailstorm_animation(ps)
				if ps.card_in_this_play_space:
					if ps.card_in_this_play_space.card_owner_id != card_owner_id:
						CardManipulation.change_max_attack(card_owner_id, card_in_play_index, -1, 2)
						CardManipulation.change_movement(
							card_owner_id, card_in_play_index, -1, 2
						)
			
			if !GameManager.is_single_player:
				for p_id in GameManager.players:
					BattleAnimation.play_hailstorm_animation.rpc_id(p_id, ps)
				if ps.card_in_this_play_space:
					if ps.card_in_this_play_space.card_owner_id != card_owner_id:
						for p_id in GameManager.players:
							CardManipulation.change_max_attack.rpc_id(
								p_id, card_owner_id, card_in_play_index, -1, 2
							)
							CardManipulation.change_movement.rpc_id(
								p_id, card_owner_id, card_in_play_index, -1, 2
							)
	
		TargetSelection.end_drag_to_select()
		TargetSelection.end_selecting()
		return true

	else:
		TargetSelection.end_drag_to_select()
		TargetSelection.end_selecting()
		Events.hide_instructions.emit()
		GameManager.battle_map.hide_finish_button()
		return false
