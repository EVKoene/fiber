extends Panel

class_name PlaySpace

var column: int
var row: int
var stat_modifier := {
	GameManager.p1_id: {
		Collections.stats.MAX_ATTACK: 0,
		Collections.stats.MIN_ATTACK: 0,
		Collections.stats.HEALTH: 0,
		Collections.stats.MOVEMENT: 0,
	},
	GameManager.p2_id: {
		Collections.stats.MAX_ATTACK: 0,
		Collections.stats.MIN_ATTACK: 0,
		Collections.stats.HEALTH: 0,
		Collections.stats.MOVEMENT: 0,
	},
}

var attributes: Array = []
var contest_space: bool
var card_in_this_play_space: CardInPlay
var conquered_by: int
var selected_for_movement := false
var territory: Territory


func _ready():
	scale *= MapSettings.play_space_size/size
	position = _calc_position()
	_set_play_space_attributes()
	_add_border()
	GameManager.ps_column_row[column][row] = self


func add_to_territory(p_id: int) -> void:
	territory = Territory.new(p_id, self)
	GameManager.battle_map.add_child(territory)


func update_stat_modifier(card_owner_id: int, stat: int, value: int) -> void:
	if GameManager.is_single_player:
		BattleManager.update_play_space_stat_modifier(card_owner_id, column, row, stat, value)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleManager.update_play_space_stat_modifier.rpc_id(
				p_id, card_owner_id, column, row, stat, value
			)


func find_play_space_path(goal_space: PlaySpace, ignore_obstacles: bool) -> PlaySpacePath:
	var ps_path: PlaySpacePath = PlaySpacePath.new(goal_space, self, ignore_obstacles)
	GameManager.battle_map.add_child(ps_path)
	return ps_path


func select_path_to_play_space(play_space_path: PlaySpacePath) -> void:
	play_space_path.show_path()
	selected_for_movement = true
	TargetSelection.play_space_selected_for_movement = self
	TargetSelection.making_selection = true
	TargetSelection.current_path = play_space_path


func adjacent_play_spaces() -> Array:
	var a_spaces: Array = []
	for ps in GameManager.play_spaces:
		match [abs(column - ps.column), abs(row - ps.row)]:
			[1, 0]:
				a_spaces.append(ps)
			[0, 1]:
				a_spaces.append(ps)

	return a_spaces


func distance_to_play_space(goal_space: PlaySpace, ignore_obstacles: bool) -> int:
	var queue: Array = [self]

	var distance: Dictionary = {
		self: 0,
	}
	while len(queue) > 0:
		var ps = queue.pop_front()
		if ps == goal_space:
			break

		for adj_ps in ps.adjacent_play_spaces():
			if adj_ps not in distance and (
				!adj_ps.card_in_this_play_space 
				or ignore_obstacles
				or adj_ps == goal_space
			):
				queue.append(adj_ps)
				distance[adj_ps] = 1 + distance[ps]

	if goal_space not in distance:
		return -1

	else:
		return distance[goal_space]


func in_play_range(play_range: int, card_owner_id: int) -> bool:
	for c in GameManager.cards_in_play[card_owner_id]:
		if distance_to_play_space(c.current_play_space, true) <= play_range:
			return true
	
	return false


func direction_from_play_space(play_space: PlaySpace) -> int:
	var direction: int
	if GameManager.is_player_1:
		if play_space.column > column:
			direction = Collections.directions.LEFT
		elif play_space.column < column:
			direction =  Collections.directions.RIGHT
		elif play_space.row > row:
			direction = Collections.directions.UP
		elif play_space.row < row:
			direction = Collections.directions.DOWN
		else:
			assert(false, "Can't discern direction relative to playspace")
	
	else:
		if play_space.column < column:
			direction = Collections.directions.LEFT
		elif play_space.column > column:
			direction =  Collections.directions.RIGHT
		elif play_space.row < row:
			direction = Collections.directions.UP
		elif play_space.row > row:
			direction = Collections.directions.DOWN
		else:
			assert(false, "Can't discern direction relative to playspace")

	return direction


func play_space_direction_in_same_line(play_space: PlaySpace) -> int:
	if play_space.column > column and play_space.row == row:
		return Collections.directions.RIGHT
	elif play_space.column < column and play_space.row == row:
		return Collections.directions.LEFT
	elif play_space.column == column and play_space.row > row:
		return Collections.directions.DOWN 
	elif play_space.column == column and play_space.row < row:
		return Collections.directions.UP
	
	return -1


func path_to_closest_movable_space(
	goal_space: PlaySpace, max_moves: int, ignore_obstacles: bool
) -> PlaySpacePath:
	var queue: Array = [goal_space]
	var tried_spaces: Array = []
	
	while len(queue) > 0:
		var ps = queue.pop_front()
		var path_to_ps = find_play_space_path(ps, ignore_obstacles)
		if path_to_ps.path_length > 0 and path_to_ps.path_length <= max_moves + 1:
			# We add 1 to the max moves because the path_length includes the starting space
			return path_to_ps
		else:
			for adj_ps in ps.adjacent_play_spaces():
				var path_to_adj_ps = find_play_space_path(adj_ps, ignore_obstacles)
				if path_to_adj_ps.path_length > 0  and path_to_adj_ps.path_length < max_moves:
					return path_to_adj_ps
				elif adj_ps not in tried_spaces and !adj_ps.card_in_this_play_space:
					queue.append(adj_ps)
					tried_spaces.append(adj_ps)
	
	return PlaySpacePath.new(goal_space, self, false)


func set_conquered_by(player_id: int) -> void:
	if GameManager.is_single_player:
		BattleManager.set_conquered_by(player_id, column, row)
		
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleManager.set_conquered_by.rpc_id(
				p_id, player_id, column, row
			)
	


func set_border() -> void:
	if conquered_by:
		match conquered_by:
			GameManager.p1_id:
				get_theme_stylebox("panel").border_color = Styling.p1_conquered_color
			GameManager.p2_id:
				get_theme_stylebox("panel").border_color = Styling.p2_conquered_color
		return
		
	if Collections.play_space_attributes.RESOURCE_SPACE in attributes:
		get_theme_stylebox("panel").border_color = Styling.resource_space_color
	else:
		get_theme_stylebox("panel").border_color = Styling.base_space_color


func highlight_space():
	get_theme_stylebox("panel").border_color = Styling.gold_color


func _add_border() -> void:
	var border := StyleBoxFlat.new()
	add_theme_stylebox_override("panel", border)
	get_theme_stylebox("panel").bg_color = Color("99999900")
	get_theme_stylebox("panel").set_border_width_all(size.x / 15)
	set_border()


func is_in_starting_area(player_id: int) -> bool:
	if (
		player_id == GameManager.p1_id 
		and Collections.play_space_attributes.P1_START_SPACE in attributes
	):
		return true
	if (
		player_id == GameManager.p2_id 
		and Collections.play_space_attributes.P2_START_SPACE in attributes
	):
		return true
	else:
		return false


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if territory:
		if (
			territory.owner_id == data.card_owner_id 
			and data.card_type == Collections.card_types.UNIT
		):
			return true
	
	if data.card_type == Collections.card_types.SPELL and data.can_target_unit(null):
		return true
	
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var c_owner_id: int = data.card_owner_id
	var h_index: int = data.hand_index
	match data.card_type:
		Collections.card_types.UNIT:
			if !GameManager.testing:
				GameManager.resources[data.card_owner_id].pay_costs(data.costs)
			if GameManager.is_single_player:
				BattleManager.play_unit(data.card_index, data.card_owner_id, column, row)
				BattleManager.remove_card_from_hand(c_owner_id, h_index)
			if !GameManager.is_single_player:
				for p_id in [GameManager.p1_id, GameManager.p2_id]:
					BattleManager.play_unit.rpc_id(
						p_id, data.card_index, data.card_owner_id, column, row
					)
					BattleManager.remove_card_from_hand.rpc_id(
						p_id, c_owner_id, h_index
					)
			if len(data.factions) == 1:
				GameManager.resources[data.card_owner_id].add_resource(data.factions[0], 1)
		Collections.card_types.SPELL:
			data.play_spell(column, row)


func _set_play_space_attributes() -> void:
	# If we want to enable multiple maps, we should load id it as an export var in this script
	attributes = MapDatabase.get_play_space_attributes(MapDatabase.maps.BASE_MAP, self)
	if Collections.play_space_attributes.RESOURCE_SPACE in attributes:
		GameManager.resource_spaces.append(self) 


func _calc_position() -> Vector2:
	return Vector2(
		MapSettings.get_column_start_x(column), 
		MapSettings.get_row_start_y(row)
	)


func _on_gui_input(event):
	var left_mouse_button_pressed = (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.pressed
	)
	
	var right_mouse_button_pressed = (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_RIGHT 
		and event.pressed
	)
	
	if (
		left_mouse_button_pressed
		and TargetSelection.selecting_spaces
		and self in TargetSelection.target_play_space_options
	):
		TargetSelection.selected_spaces.append(self)
		if len(TargetSelection.selected_spaces) == TargetSelection.number_of_spaces_to_select:
			TargetSelection.space_selection_finished.emit()

	elif left_mouse_button_pressed and !TargetSelection.making_selection:
		TargetSelection.end_selecting()
	
	if (
		right_mouse_button_pressed
		and GameManager.turn_manager.turn_actions_enabled
		and TargetSelection.card_selected_for_movement
		and !card_in_this_play_space
		and !TargetSelection.current_path
	):
		var card: CardInPlay = TargetSelection.card_selected_for_movement
		var card_path = card.current_play_space.find_play_space_path(self, card.move_through_units)
		
		if card_path.path_length > 0 and card_path.path_length <= card.movement + 1:
			select_path_to_play_space(card_path)

	elif (
		right_mouse_button_pressed
		and GameManager.turn_manager.turn_actions_enabled
		and TargetSelection.card_selected_for_movement
		and !card_in_this_play_space
		and TargetSelection.play_space_selected_for_movement != self
		and TargetSelection.current_path
	):
		var card: CardInPlay = TargetSelection.card_selected_for_movement
		TargetSelection.current_path.extend_path(self)
		
		if (
			TargetSelection.current_path.path_length > 0 
			and TargetSelection.current_path.path_length <= card.movement + 1
		):
			TargetSelection.current_path.show_path()
			selected_for_movement = true
			TargetSelection.play_space_selected_for_movement = self
			TargetSelection.making_selection = true
		
		else:
			TargetSelection.clear_paths()
			var card_path = card.current_play_space.find_play_space_path(self, card.move_through_units)
		
			if card_path.path_length > 0 and card_path.path_length <= card.movement + 1:
				select_path_to_play_space(card_path)
			
			else:
				TargetSelection.end_selecting()
				Events.clear_paths.emit()

	elif (
		right_mouse_button_pressed
		and GameManager.turn_manager.turn_actions_enabled
		and TargetSelection.card_selected_for_movement
		and !card_in_this_play_space
		and selected_for_movement
	):
		GameManager.turn_manager.turn_actions_enabled = false
		TargetSelection.card_selected_for_movement.move_over_path(TargetSelection.current_path)
		TargetSelection.card_selected_for_movement.exhaust()
		TargetSelection.end_selecting()
		GameManager.turn_manager.turn_actions_enabled = true
