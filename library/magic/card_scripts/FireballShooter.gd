extends CardInPlay


class_name FireballShooter


func _init():
	abilities = [
		{
			"FuncName": "shoot_fireballs",
			"FuncText": "ShootFireballs",
			"AbilityCosts": Costs.new(0, 0, 0, 0),
		},
	]


func shoot_fireballs() -> bool:
	GameManager.turn_manager.turn_actions_enabled = false
	var play_space_options: Array = []
	for ps in GameManager.play_spaces:
		if ps == current_play_space:
			continue
		elif ps.column == current_play_space.column or ps.row == current_play_space.row:
			ps.highlight_space()
			play_space_options.append(ps)
			
	Events.show_instructions.emit("Choose direction to shoot fireballs")
	TargetSelection.select_play_spaces(1, play_space_options)
	
	await TargetSelection.space_selection_finished
	if len(TargetSelection.selected_spaces) == 0:
		TargetSelection.end_selecting()
		return false
	
	elif len(TargetSelection.selected_spaces) == 1:
		match (
			current_play_space.play_space_direction_in_same_line(TargetSelection.selected_spaces[0])
		):
			Collections.directions.DOWN:
				for ps_row in range(MapSettings.n_rows - current_play_space.row - 1):
					await get_tree().create_timer(0.2).timeout
					call("burn_and_damage", current_play_space.column, ps_row + 1)
			
			Collections.directions.UP:
				for ps_row in range(current_play_space.row):
					await get_tree().create_timer(0.2).timeout
					call(
						"burn_and_damage", current_play_space.column,
						current_play_space.row - ps_row - 1
					)
			
			Collections.directions.RIGHT:
				for ps_column in range(MapSettings.n_columns - current_play_space.column - 1):
					await get_tree().create_timer(0.2).timeout
					call("burn_and_damage", ps_column + 1, current_play_space.row)
			
			Collections.directions.LEFT:
				for ps_column in range(current_play_space.column):
					await get_tree().create_timer(0.2).timeout
					call(
						"burn_and_damage", current_play_space.column - ps_column - 1, 
						current_play_space.row
					)
	
		TargetSelection.end_selecting()
		return true
	
	else:
		assert(false, "More than 1 space selected while 1 maximum space was expected")
		return false


func burn_and_damage(ps_column: int, ps_row: int) -> void:
	for p_id in GameManager.players:
		BattleAnimation.play_burn_animation.rpc_id(p_id, ps_column, ps_row)
	
	var play_space: PlaySpace = GameManager.ps_column_row[ps_column][ps_row]
	if play_space.card_in_this_play_space:
		play_space.card_in_this_play_space.resolve_damage(1)


func resolve_ability_for_ai() -> void:
	# TODO: This can probably be heavily trimmed down and written more elegantly. AI can also be
	# heavily improved here by looking for priority targets or targets that die from 1 damage.
	var enemies_in_direction := {
		Collections.directions.RIGHT: 0,
		Collections.directions.LEFT: 0,
		Collections.directions.UP: 0,
		Collections.directions.DOWN: 0,
	}
	
	for ps in GameManager.play_spaces:
		for d in Collections.directions:
			if (
				ps.card_in_this_play_space 
				and current_play_space.play_space_direction_in_same_line(ps) == d
			):
				if ps.card_in_this_play_space.card_owner_id != card_owner_id:
					enemies_in_direction[d] += 1
	
	var highest_number_of_enemies_direction = max(enemies_in_direction.values())
	
	# We prefer striking down as it has the highest change of hitting enemies the player wants to
	# protect
	if enemies_in_direction[Collections.directions.DOWN] == highest_number_of_enemies_direction:
		for ps_row in range(MapSettings.n_rows - current_play_space.row - 1):
			var play_space = GameManager.ps_column_row[
				current_play_space.column
			][ps_row + 1]
			await get_tree().create_timer(0.2).timeout
			call("burn_and_damage", play_space)
	# Next we go for striking up to eliminate potential enemies in the backline, but improving
	# target selection here would be welcome
	elif enemies_in_direction[Collections.directions.UP] == highest_number_of_enemies_direction:
		for ps_row in range(current_play_space.row):
			var play_space = GameManager.ps_column_row[
				current_play_space.column][current_play_space.row - ps_row]
			await get_tree().create_timer(0.2).timeout
			call("burn_and_damage", play_space)
	elif enemies_in_direction[Collections.directions.RIGHT] == highest_number_of_enemies_direction:
		for ps_column in range(MapSettings.n_columns - current_play_space.column):
			var play_space = GameManager.ps_column_row[
				ps_column + 1][current_play_space.row]
			await get_tree().create_timer(0.2).timeout
			call("burn_and_damage", play_space)
	else:
		for ps_column in range(current_play_space.column):
			var play_space = GameManager.ps_column_row[
				current_play_space.column - ps_column][current_play_space.row]
			await get_tree().create_timer(0.2).timeout
			call("burn_and_damage", play_space)
	
	exhaust()
	TargetSelection.end_selecting()


func should_use_ability_ai() -> bool:
	for ps in GameManager.play_spaces:
		if (
			current_play_space.play_space_direction_in_same_line(ps) == Collections.directions.RIGHT
			or current_play_space.play_space_direction_in_same_line(ps) == Collections.directions.DOWN
			or current_play_space.play_space_direction_in_same_line(ps) == Collections.directions.LEFT
			or current_play_space.play_space_direction_in_same_line(ps) == Collections.directions.UP
		) and ps.card_in_this_play_space:
			if ps.card_in_this_play_space.card_owner_id != card_owner_id:
				return true
	
	return false



func is_ability_to_use_now() -> bool:
	for ps in GameManager.play_spaces:
		if (
			current_play_space.play_space_direction_in_same_line(ps) == Collections.directions.RIGHT
			or current_play_space.play_space_direction_in_same_line(ps) == Collections.directions.DOWN
			or current_play_space.play_space_direction_in_same_line(ps) == Collections.directions.LEFT
			or current_play_space.play_space_direction_in_same_line(ps) == Collections.directions.UP
		) and ps.card_in_this_play_space:
			if ps.card_in_this_play_space.card_owner_id != card_owner_id:
				return true
	
	return false
