extends Panel

class_name PlaySpace


@export var column: int
@export var row: int
@export var stat_modifier := {
	GameManager.p1_id: {
		Collections.stats.ATTACK: 0,
		Collections.stats.HEALTH: 0,
		Collections.stats.MOVEMENT: 0,
	},
	GameManager.p2_id: {
		Collections.stats.ATTACK: 0,
		Collections.stats.HEALTH: 0,
		Collections.stats.MOVEMENT: 0,
	},
}

var attributes: Array = []
var contest_space: bool
var border_style: StyleBox
var card_in_this_play_space: CardInPlay
var selected_for_movement := false


func _ready():
	scale *= MapSettings.play_space_size/size
	position = _calc_position()
	_set_play_space_attributes()
	set_border()
	GameManager.ps_column_row[column][row] = self
	MapSettings.play_spaces.append(self)


func set_border() -> void:
	if Collections.play_space_attributes.DRAW_CARD_SPACE in attributes:
		border_style = Styling.draw_card_space_border
	elif Collections.play_space_attributes.RESOURCE_SPACE in attributes:
		border_style = Styling.resource_space_border
	elif Collections.play_space_attributes.P1_START_SPACE in attributes:
		border_style = Styling.p1_start_space_border
	elif Collections.play_space_attributes.P2_START_SPACE in attributes:
		border_style = Styling.p2_start_space_border
	else:
		border_style = Styling.base_space_border

	add_theme_stylebox_override("panel", border_style)
	get_theme_stylebox("panel").border_width_left = size.x / 15
	get_theme_stylebox("panel").border_width_right = size.x / 15
	get_theme_stylebox("panel").border_width_top = size.y / 15
	get_theme_stylebox("panel").border_width_bottom = size.y / 15


func highlight_space():
	border_style = load("res://styling/card_borders/CardSelectedBorder.tres")
	add_theme_stylebox_override("panel", border_style)


func in_starting_area(card: CardInHand) -> bool:
	if (
		card.card_owner_id == GameManager.p1_id 
		and Collections.play_space_attributes.P1_START_SPACE in attributes
	):
		return true
	elif (
		card.card_owner_id == GameManager.p2_id 
		and Collections.play_space_attributes.P2_START_SPACE in attributes
	):
		return true
	else:
		return false


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
	for ps in MapSettings.play_spaces:
		match [abs(column - ps.column), abs(row - ps.row)]:
			[1, 0]:
				a_spaces.append(ps)
			[0, 1]:
				a_spaces.append(ps)

	return a_spaces


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if in_starting_area(data) and data.card_type == Collections.card_types.UNIT:
		return true
	if data.card_type == Collections.card_types.SPELL and data.can_target_unit(null):
		return true
	
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	match [GameManager.is_server, data.card_type]:
		[true, Collections.card_types.UNIT]:
			data.play_unit(column, row)
		[true, Collections.card_types.SPELL]:
			assert(false, "Playing spells not implemented yet")
		[false, Collections.card_types.UNIT]:
			data.play_unit.rpc_id(1, column, row)
		[false, Collections.card_types.SPELL]:
			assert(false, "Playing spells not implemented yet")


func _set_play_space_attributes() -> void:
	# If we want to enable multiple maps, we should load id it as an export var in this script
	attributes = MapDatabase.get_play_space_attributes(MapDatabase.maps.BASE_MAP, self)
	
	if (
		Collections.play_space_attributes.RESOURCE_SPACE in attributes 
		or Collections.play_space_attributes.DRAW_CARD_SPACE in attributes
	):
		GameManager.resource_spaces.append(self) 


func _calc_position() -> Vector2:
	return Vector2(
		MapSettings.get_column_start_x(column), 
		MapSettings.get_row_start_y(row)
	)


func _on_gui_input(event):
	var right_mouse_button_pressed = (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_RIGHT 
		and event.pressed
	)
	
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
			TargetSelection.end_selecting()
			Events.clear_paths.emit()

	elif (
		right_mouse_button_pressed
		and GameManager.turn_manager.turn_actions_enabled
		and TargetSelection.card_selected_for_movement
		and !card_in_this_play_space
		and selected_for_movement
	):
		TargetSelection.card_selected_for_movement.move_over_path(TargetSelection.current_path)
