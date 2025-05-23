extends CardInPlay

class_name VolcanicEruption


func resolve_spell() -> bool:
	TargetSelection.can_drag_to_select = true
	TargetSelection.n_highest_axis_to_select = 4
	TargetSelection.n_lowest_axis_to_select = 4
	TargetSelection.drag_selection_range = 1
	Events.show_instructions.emit("Choose a 4x4 area in range 1 of one of your units")
	GameManager.battle_map.show_finish_button()
	TargetSelection.making_selection = true
	GameManager.turn_manager.set_turn_actions_enabled(false)

	await TargetSelection.space_selection_finished

	if len(TargetSelection.selected_spaces) >= 1:
		for ps in TargetSelection.selected_spaces:
			if GameManager.is_single_player:
				BattleAnimation.play_burn_animation(ps.column, ps.row)

			if !GameManager.is_single_player:
				for p_id in GameManager.players:
					BattleAnimation.play_burn_animation.rpc_id(p_id, ps.column, ps.row)

			if ps.card_in_this_play_space:
				if ps.card_in_this_play_space.card_owner_id != card_owner_id:
					ps.card_in_this_play_space.resolve_damage(2)

		Events.hide_instructions.emit()
		TargetSelection.end_selecting()
		TargetSelection.end_drag_to_select()
		GameManager.turn_manager.set_turn_actions_enabled(true)

		return true

	else:
		Events.hide_instructions.emit()
		TargetSelection.end_selecting()
		TargetSelection.end_drag_to_select()
		Events.hide_instructions.emit()
		GameManager.battle_map.hide_finish_button()
		GameManager.turn_manager.set_turn_actions_enabled(true)

		return false


func is_spell_to_play_now() -> bool:
	if len(AIHelper.areas_in_range_with_most_enemy_units(1, 4, 4)) >= 1:
		return true

	return false


func resolve_spell_for_ai() -> void:
	var selected_area: Array = AIHelper.areas_in_range_with_most_enemy_units(1, 4, 4).pick_random()

	for ps in selected_area:
		BattleAnimation.play_burn_animation(ps.column, ps.row)
		if ps.card_in_this_play_space:
			if ps.card_in_this_play_space.card_owner_id != card_owner_id:
				ps.card_in_this_play_space.resolve_damage(2)

	Events.spell_resolved_for_ai.emit()
	BattleSynchronizer.finish_resolve()
