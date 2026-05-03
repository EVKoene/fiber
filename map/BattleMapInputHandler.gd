class_name BattleMapInputHandler

enum InputContext { NONE, CARD_HAND, PLAY_SPACE, TARGET_SELECTION, INSTRUCTION }

var parent: BattleMap
var current_input_context: InputContext = InputContext.NONE


func _init(battle_map: BattleMap) -> void:
	parent = battle_map


func handle_input(_event):
	if (
		Input.is_action_just_pressed("ui_accept")
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	):
		if Tutorial.is_awaiting_tutorial_input:
			Tutorial.continue_tutorial()
			return

	match current_input_context:
		InputContext.CARD_HAND:
			_handle_card_hand_input()
		InputContext.PLAY_SPACE:
			_handle_play_space_input()
		InputContext.TARGET_SELECTION:
			pass
		InputContext.INSTRUCTION:
			_handle_instruction_input()


func handle_unhandled_input(event):
	if !GameManager.is_ready_to_play:
		return

	match current_input_context:
		InputContext.TARGET_SELECTION:
			_handle_target_selection_input(event)
		_:
			if (
				event is InputEventMouseButton
				and event.button_index == MOUSE_BUTTON_LEFT
				and TargetSelection.can_drag_to_select
			):
				_handle_drag_selection_start(event)
			elif event is InputEventMouseMotion and TargetSelection.dragging_to_select:
				parent.queue_redraw()
			elif (
				event is InputEventMouseButton
				and event.button_index == MOUSE_BUTTON_LEFT
				and event.pressed
			):
				TargetSelection.end_selecting()


func draw():
	if TargetSelection.dragging_to_select:
		parent.draw_rect(
			Rect2(
				TargetSelection.drag_start,
				parent.get_global_mouse_position() - TargetSelection.drag_start
			),
			Color.YELLOW,
			false,
			2.0
		)


func _handle_card_hand_input() -> void:
	if !GameManager.turn_manager.turn_actions_enabled:
		return
	if Input.is_action_just_pressed("ui_accept"):
		for card in GameManager.cards_in_hand[GameManager.player_id]:
			if card.hovered:
				card.play_by_hitting_enter()
				break
	if Input.is_action_just_pressed("ui_right"):
		pass


func _handle_play_space_input() -> void:
	pass


func _handle_target_selection_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and TargetSelection.can_drag_to_select
	):
		if event.pressed:
			TargetSelection.dragging_to_select = true
			TargetSelection.drag_start = event.position
		elif TargetSelection.dragging_to_select:
			TargetSelection.clear_selections()
			TargetSelection.dragging_to_select = false
			parent.queue_redraw()
			TargetSelection.drag_end = event.position
			TargetSelection.select_rect.extents = (
				abs(TargetSelection.drag_end - TargetSelection.drag_start) / 2
			)
			for column in MapSettings.n_columns:
				if (
					(
						MapSettings.get_column_end_x(column) >= TargetSelection.drag_start.x
						and MapSettings.get_column_start_x(column) <= TargetSelection.drag_end.x
						and column not in TargetSelection.selected_columns
					)
					or (
						MapSettings.get_column_start_x(column) <= TargetSelection.drag_start.x
						and MapSettings.get_column_end_x(column) >= TargetSelection.drag_end.x
						and column not in TargetSelection.selected_columns
					)
				):
					TargetSelection.selected_columns.append(column)
			for row in MapSettings.n_rows:
				if (
					(
						MapSettings.get_row_end_y(row) >= TargetSelection.drag_start.y
						and MapSettings.get_row_start_y(row) <= TargetSelection.drag_end.y
						and row not in TargetSelection.selected_rows
					)
					or (
						MapSettings.get_row_start_y(row) <= TargetSelection.drag_start.y
						and MapSettings.get_row_end_y(row) >= TargetSelection.drag_end.y
						and row not in TargetSelection.selected_rows
					)
				):
					TargetSelection.selected_rows.append(row)

			if (
				(
					(
						len(TargetSelection.selected_columns)
						<= TargetSelection.n_highest_axis_to_select
					)
					and (
						len(TargetSelection.selected_rows)
						<= TargetSelection.n_lowest_axis_to_select
					)
				)
				or (
					len(TargetSelection.selected_columns) <= TargetSelection.n_lowest_axis_to_select
					and (
						len(TargetSelection.selected_rows)
						<= TargetSelection.n_highest_axis_to_select
					)
				)
			):
				for ps in GameManager.play_spaces:
					if (
						ps.column in TargetSelection.selected_columns
						and ps.row in TargetSelection.selected_rows
					):
						TargetSelection.selected_spaces.append(ps)
				var selection_in_range := false
				for ps in TargetSelection.selected_spaces:
					if PlaySpaceHelper.is_space_in_range(
						ps, GameManager.player_id, TargetSelection.drag_selection_range
					):
						selection_in_range = true
						break
				if selection_in_range:
					parent.ui.show_finish_button()
					for ps in TargetSelection.selected_spaces:
						ps.highlight_space()
				else:
					parent.ui.hide_finish_button()
					TargetSelection.clear_selections()

	elif event is InputEventMouseMotion and TargetSelection.dragging_to_select:
		parent.queue_redraw()

	elif (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	):
		TargetSelection.end_selecting()


func _handle_drag_selection_start(event: InputEvent) -> void:
	if event.pressed:
		TargetSelection.dragging_to_select = true
		TargetSelection.drag_start = event.position


func _handle_instruction_input() -> void:
	if parent.awaiting_input:
		Events.instruction_input_received.emit()
	if GameManager.turn_manager.can_start_turn:
		GameManager.turn_manager.can_start_turn = false
		if GameManager.is_single_player:
			GameManager.turn_manager.start_turn(GameManager.p1_id)
		if !GameManager.is_single_player:
			GameManager.turn_manager.start_turn.rpc_id(1, GameManager.player_id)
