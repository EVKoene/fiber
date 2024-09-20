extends CardInPlay


class_name Rhinoceros

var movement_this_turn: int = 0


func call_triggered_funcs(trigger: int, _triggering_card: CardInPlay) -> void:
	if trigger == Collections.triggers.TURN_ENDED:
		movement_this_turn = 0


func spaces_in_range(_range_to_check: int, _ignore_obstacles: bool) -> Array:
	var spaces: Array = []
	var space_higher_column: PlaySpace
	var space_lower_column: PlaySpace
	var space_higher_row: PlaySpace
	var space_lower_row: PlaySpace
	
	for c in range(MapSettings.n_columns - current_play_space.column):
		var column_to_check: int = current_play_space.column + c
		var space_to_check = GameManager.ps_column_row[column_to_check][current_play_space.row]
		
		if space_to_check == current_play_space:
			continue
		elif !space_to_check.card_in_this_play_space:
			space_higher_column = space_to_check
			continue
		else:
			break

	for c in range(current_play_space.column + 1):
		var column_to_check: int = current_play_space.column - c
		var space_to_check = GameManager.ps_column_row[column_to_check][current_play_space.row]
		
		if space_to_check == current_play_space:
			continue
		elif !space_to_check.card_in_this_play_space:
			space_lower_column = space_to_check
			continue
		else:
			break

	for r in range(MapSettings.n_rows - current_play_space.row):
		var row_to_check: int = current_play_space.row + r
		var space_to_check = GameManager.ps_column_row[current_play_space.column][row_to_check]
		if space_to_check == current_play_space:
			continue
		elif !space_to_check.card_in_this_play_space:
			space_higher_row = space_to_check
			continue
		else:
			break

	for r in range(current_play_space.row + 1):
		var row_to_check: int = current_play_space.row - r
		var space_to_check = GameManager.ps_column_row[current_play_space.column][row_to_check]
		if space_to_check == current_play_space:
			continue
		elif !space_to_check.card_in_this_play_space:
			space_lower_row = space_to_check
			continue
		else:
			break

	for s in [space_higher_column, space_lower_column, space_higher_row, space_lower_row]:
		if s:
			spaces.append(s)

	return spaces


func move_over_path(path: PlaySpacePath) -> void:
	GameManager.turn_manager.turn_actions_enabled = false
	TargetSelection.clear_arrows()
	if path.path_length > 0:
		movement_this_turn = path.path_length
		for s in len(path.path_spaces):
			# We ignore the first playspace in path because it's the space the card is in
			if s == 0:
				continue
			else:
				move_to_play_space(path.path_spaces[s].column, path.path_spaces[s].row)
				await get_tree().create_timer(0.05).timeout
	
	TargetSelection.end_selecting()
	GameManager.turn_manager.turn_actions_enabled = true
	for p_id in GameManager.players:
		BattleManager.set_progress_bars.rpc_id(p_id)


func attack_card(target_card: CardInPlay) -> void:
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		BattleAnimation.animate_attack.rpc_id(
			p_id, card_owner_id, card_in_play_index, 
			target_card.current_play_space.direction_from_play_space(current_play_space)
		)
	
	if movement_this_turn >= 2:
		deal_damage_to_card(target_card, 1)
		await get_tree().create_timer(0.5).timeout
		resolve_damage(1)
	
	if is_instance_valid(target_card):
		deal_damage_to_card(target_card, int(randf_range(min_attack, max_attack)))
