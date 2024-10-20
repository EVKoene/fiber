extends CardInPlay


class_name HailStorm

func resolve_spell(_selected_column: int, _selected_row: int) -> bool:
	TargetSelection.can_drag_to_select = true
	TargetSelection.n_highest_axis_to_select = 3
	TargetSelection.n_lowest_axis_to_select = 3
	TargetSelection.drag_selection_range = 1
	Events.show_instructions.emit("Choose a 3x3 area in range 1 of one of your units")
	GameManager.lobby.battle_map.show_finish_button()
	TargetSelection.making_selection = true
	GameManager.lobby.turn_manager.set_turn_actions_enabled(false)
	
	await TargetSelection.space_selection_finished
	
	GameManager.lobby.battle_map.hide_finish_button()
	if len(TargetSelection.selected_spaces) >= 1:
		for ps in TargetSelection.selected_spaces:
			if GameManager.lobby.is_single_player:
				BattleAnimation.play_hailstorm_animation(ps)
			if !GameManager.lobby.is_single_player:
				for p_id in GameManager.lobby.players:
					BattleAnimation.play_hailstorm_animation.rpc_id(p_id, ps)
				
			if ps.card_in_this_play_space:
				if ps.card_in_this_play_space.card_owner_id != card_owner_id:
					var target_card: CardInPlay = ps.card_in_this_play_space
					CardManipulation.change_battle_stat(
						Collections.stats.MAX_ATTACK, target_card.card_owner_id, 
						target_card.card_in_play_index, -1, 2
					)
					CardManipulation.change_battle_stat(
						Collections.stats.MOVEMENT, target_card.card_owner_id, 
						target_card.card_in_play_index, -1, 2
					)
		
		TargetSelection.end_drag_to_select()
		TargetSelection.end_selecting()
		return true

	else:
		TargetSelection.end_drag_to_select()
		TargetSelection.end_selecting()
		Events.hide_instructions.emit()
		GameManager.lobby.battle_map.hide_finish_button()
		return false
