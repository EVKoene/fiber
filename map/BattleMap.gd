extends Node2D

class_name BattleMap

@onready var play_space_scene: PackedScene = preload("res://map/play_space/PlaySpace.tscn")
@onready var card_scene: PackedScene = preload("res://card/card_states/CardInPlay.tscn")
@onready var resource_bar_scene: PackedScene = preload("res://player/ResourceBar.tscn")
@onready var card_pick_scene: PackedScene = preload("res://card/CardPickScreen.tscn")
@onready var card_resolve_scene := load("res://card/card_states/CardResolve.tscn")

var map = MapDatabase.maps.BASE_MAP
var map_data = MapDatabase.map_data[map]
var end_turn_button_container: PanelContainer
var instruction_container: PanelContainer
var card_text_container: PanelContainer
var card_text_container_label: Label
var tutorial_container: PanelContainer
var gold_gained_container: PanelContainer
var battle_zoom_preview: ZoomPreview
var text_box: Panel
var finish_button_container: PanelContainer
var is_tutorial := false
var awaiting_input := false
var highlight_instruction_container_tween: Tween
var highlight_finish_button_tween: Tween
var showing_instruction := false
var showing_finish_button := false


func _ready():
	if GameManager.is_single_player:
		_create_ai_player()
	$AudioStreamPlayer2D.play()
	GameManager.battle_map = self
	_create_battle_map()
	_set_zoom_preview_position_and_size()
	_set_end_turn_button()
	_set_finish_button()
	_set_resolve_spell_button()
	_set_resource_bars_position_and_size()
	_set_text_containers()
	_create_progress_bars()
	# Because create_starting_territory() calls rpc funcs we wait a second for both players to setup
	await get_tree().create_timer(1).timeout
	_create_starting_territory()

	if GameManager.is_single_player:
		GameManager.setup_game()
	elif GameManager.is_player_1:
		# To make sure the cards and card orders are always the same for both players, we only create
		# the decks on the server
		GameManager.setup_game.rpc_id(1)

	Events.show_instructions.connect(show_instructions)
	Events.hide_instructions.connect(hide_instructions)


func _create_ai_player() -> void:
	GameManager.ai_player = AIPlayer.new()
	GameManager.ai_player_id = GameManager.p2_id
	GameManager.ai_player.player_id = GameManager.p2_id
	GameManager.ai_player.ai_turn_manager = AITurnManager.new()


@rpc("any_peer", "call_local")
func pick_card_option(card_indices: Array) -> void:
	var card_pick_screen := card_pick_scene.instantiate()
	card_pick_screen.card_indices = card_indices
	card_pick_screen.size = MapSettings.total_screen
	call_deferred("add_child", card_pick_screen)


@rpc("any_peer", "call_local")
func create_card_resolve(card_owner_id: int, cih_index: int, column: int, row: int) -> void:
	GameManager.turn_manager.set_turn_actions_enabled(false)

	var card_resolve = card_resolve_scene.instantiate()
	var card_in_hand = GameManager.cards_in_hand[card_owner_id][cih_index]
	card_resolve.card_index = card_in_hand.card_index
	card_resolve.column = column
	card_resolve.row = row
	card_resolve.card_owner_id = card_in_hand.card_owner_id
	card_resolve.card_in_hand_index = cih_index
	card_resolve.size = MapSettings.total_screen
	add_child(card_resolve)


func show_text(text_to_show: String) -> void:
	$TextBox/Panel/Label.text = text_to_show
	$TextBox.show()


func hide_text() -> void:
	$TextBox.hide()


func _create_battle_map() -> void:
	MapSettings.n_progress_bars = map_data["SpacesToWin"]
	_set_area_sizes()
	_set_play_space_size()
	_create_play_spaces()


func _set_area_sizes() -> void:
	MapSettings.play_area_size = MapSettings.total_screen * Vector2(0.8, 0.9)
	MapSettings.opponent_area_start = Vector2(0, 0)
	MapSettings.opponent_area_end = Vector2(
		MapSettings.play_area_size.x,
		(MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2
	)

	MapSettings.play_area_start = Vector2(
		0, (MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2
	)
	MapSettings.play_area_end = Vector2(
		MapSettings.play_area_size.x,
		(
			MapSettings.play_area_size.y
			+ (MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2
		)
	)

	MapSettings.own_area_start = Vector2(
		0,
		(
			MapSettings.play_area_size.y
			+ (MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2
		)
	)
	MapSettings.own_area_end = Vector2(MapSettings.play_area_size.x, MapSettings.total_screen.y)


func _set_play_space_size() -> void:
	var min_column_length: float = MapSettings.play_area_size.x / float(map_data["Columns"])
	var min_row_length: float = MapSettings.play_area_size.y / float(map_data["Rows"])

	var ps_size: int = min(min_column_length, min_row_length)

	MapSettings.play_space_size = Vector2(ps_size, ps_size)
	# TODO: Calculate an exact size based on borderwidth of playspace and card border
	MapSettings.card_in_play_size = Vector2(ps_size, ps_size) * 0.9
	MapSettings.card_in_hand_size = Vector2(
		(MapSettings.own_area_end.x - MapSettings.own_area_start.x) / 7,
		MapSettings.own_area_end.y - MapSettings.own_area_start.y
	)
	MapSettings.card_option_size = MapSettings.card_in_play_size * 2


func _create_play_spaces() -> void:
	MapSettings.n_columns = map_data["Columns"]
	MapSettings.n_rows = map_data["Rows"]
	for column in map_data["Columns"]:
		GameManager.ps_column_row[column] = {}
		for row in map_data["Rows"]:
			var play_space: PlaySpace = play_space_scene.instantiate()
			play_space.column = column
			play_space.row = row
			add_child(play_space)
			GameManager.play_spaces.append(play_space)


func _create_starting_territory() -> void:
	for ps in map_data["P1Territory"]:
		GameManager.ps_column_row[int(ps.x)][int(ps.y)].add_to_territory(GameManager.p1_id)
	for ps in map_data["P2Territory"]:
		GameManager.ps_column_row[int(ps.x)][int(ps.y)].add_to_territory(GameManager.p2_id)
	for ps in map_data["P1StartingConqueredSpaces"]:
		GameManager.ps_column_row[int(ps.x)][int(ps.y)].set_conquered_by(GameManager.p1_id)
	for ps in map_data["P2StartingConqueredSpaces"]:
		GameManager.ps_column_row[int(ps.x)][int(ps.y)].set_conquered_by(GameManager.p2_id)


func _set_end_turn_button() -> void:
	end_turn_button_container = $EndTurnButtonContainer
	$EndTurnButtonContainer.size.x = MapSettings.total_screen.x / 10
	$EndTurnButtonContainer.size.y = MapSettings.total_screen.y / 10
	$EndTurnButtonContainer.position.x = MapSettings.total_screen.x - $EndTurnButtonContainer.size.x
	$EndTurnButtonContainer.position.y = MapSettings.total_screen.y - $EndTurnButtonContainer.size.y
	MapSettings.end_turn_button_size = $EndTurnButtonContainer.size
	$EndTurnButtonContainer/EndTurnButton.text = "End your turn!"


func hide_finish_button() -> void:
	showing_finish_button = false
	$FinishButtonContainer.hide()


func show_finish_button() -> void:
	showing_finish_button = true
	_tween_highlight_finish_button()
	$FinishButtonContainer.show()


func _set_finish_button() -> void:
	finish_button_container = $FinishButtonContainer
	$FinishButtonContainer/FinishButton.text = "Finish"
	finish_button_container.size.y = end_turn_button_container.size.y
	finish_button_container.size.x = end_turn_button_container.size.x
	finish_button_container.position.x = (
		MapSettings.total_screen.x
		- end_turn_button_container.size.x
		- finish_button_container.size.x
	)
	finish_button_container.get_theme_stylebox("panel").set_border_width_all(
		finish_button_container.size.x / 15
	)
	finish_button_container.position.y = MapSettings.total_screen.y - finish_button_container.size.y


@rpc("any_peer", "call_local")
func show_resolve_spell_button() -> void:
	$ResolveSpellButton.show()


func _set_resolve_spell_button() -> void:
	var button = $ResolveSpellButton
	button.text = "Resolve"
	button.custom_minimum_size.y = MapSettings.play_space_size.y / 2
	button.custom_minimum_size.x = MapSettings.play_space_size.x
	button.position.x = MapSettings.total_screen.x - MapSettings.play_space_size.x
	button.position.y = MapSettings.total_screen.y * 0.8


func _set_zoom_preview_position_and_size() -> void:
	var zoom_preview_size: Vector2 = Vector2(
		MapSettings.total_screen.x * 0.2, MapSettings.total_screen.x * 0.2
	)
	# Multiplying the zoom_preview_size.x with 1.1 to adjust for border size
	$BattleZoomPreview.position.x = MapSettings.total_screen.x - zoom_preview_size.x * 1.05
	$BattleZoomPreview.position.y = MapSettings.play_area_start.y
	$BattleZoomPreview.scale.x *= zoom_preview_size.x / $BattleZoomPreview.size.x
	$BattleZoomPreview.scale.y *= zoom_preview_size.x / $BattleZoomPreview.size.y
	MapSettings.zoom_preview_size = zoom_preview_size
	GameManager.zoom_preview = $BattleZoomPreview
	battle_zoom_preview = $BattleZoomPreview


func _set_resource_bars_position_and_size() -> void:
	var rb_1 = resource_bar_scene.instantiate()
	var rb_2 = resource_bar_scene.instantiate()

	match GameManager.is_player_1:
		true:
			rb_1.position.y = (
				MapSettings.total_screen.y
				- MapSettings.resource_bar_size.y
				- MapSettings.end_turn_button_size.y
			)
			rb_2.position.y = 0
		false:
			rb_2.position.y = (
				MapSettings.total_screen.y
				- MapSettings.resource_bar_size.y
				- MapSettings.end_turn_button_size.y
			)
			rb_1.position.y = 0

	for rb in [rb_1, rb_2]:
		rb.position.x = MapSettings.total_screen.x - MapSettings.resource_bar_size.x
		rb.scale.x *= MapSettings.resource_bar_size.x / rb.size.x
		rb.scale.y *= MapSettings.resource_bar_size.y / rb.size.y

	GameManager.resource_bars[GameManager.p1_id] = rb_1
	GameManager.resource_bars[GameManager.p2_id] = rb_2
	add_child(rb_1)
	add_child(rb_2)


func _create_progress_bars() -> void:
	GameManager.progress_bars[GameManager.p1_id] = []
	GameManager.progress_bars[GameManager.p2_id] = []

	# In the future we probably want players to get all resource spaces on their half + the ones
	# center. For now it's total number / 2 however.
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		for b in MapSettings.n_progress_bars:
			var progress_bar = ProgressBar.new()
			var progress_bar_y_size = MapSettings.play_space_size.y / MapSettings.n_progress_bars
			add_child(progress_bar)
			progress_bar.custom_minimum_size.x = MapSettings.play_space_size.x / 4
			progress_bar.custom_minimum_size.y = progress_bar_y_size
			progress_bar.position.x = MapSettings.get_column_end_x(MapSettings.n_columns) + b * progress_bar_y_size
			progress_bar.rotation_degrees = 90
			progress_bar.show_percentage = false
			var sb = StyleBoxFlat.new()
			progress_bar.add_theme_stylebox_override("fill", sb)
			GameManager.progress_bars[p_id].append(progress_bar)
			match [GameManager.is_player_1, p_id]:
				[true, GameManager.p1_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 + progress_bar.size.y
					sb.bg_color = Color.hex(0x3b3be7dc)
				[true, GameManager.p2_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 - progress_bar.size.y
					sb.bg_color = Color.hex(0xf3131edc)
				[false, GameManager.p1_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 - progress_bar.size.y
					sb.bg_color = Color.hex(0x3b3be7dc)
				[false, GameManager.p2_id]:
					progress_bar.position.y = MapSettings.total_screen.y / 2 + progress_bar.size.y
					sb.bg_color = Color.hex(0xf3131edc)


func hide_instructions() -> void:
	showing_instruction = false
	$InstructionContainer.hide()


func show_instructions(instruction_text: String) -> void:
	showing_instruction = true
	_tween_highlight_instruction_container()
	$InstructionContainer/InstructionText.text = instruction_text
	$InstructionContainer.show()


func set_tutorial_container() -> void:
	tutorial_container = $TutorialContainer
	$TutorialContainer.position.x = MapSettings.total_screen.x / 2 - $TutorialContainer.size.x
	$TutorialContainer.position.y = MapSettings.total_screen.y / 2 - $TutorialContainer.size.y / 2
	$TutorialContainer.move_to_front()


func hide_tutorial_text() -> void:
	$TutorialContainer.hide()


func show_tutorial_text(tutorial_text: String) -> void:
	$TutorialContainer/TutorialText.text = tutorial_text
	$TutorialContainer.show()


func _set_text_containers() -> void:
	$TextBox.size = MapSettings.total_screen
	text_box = $TextBox
	_set_gold_gained_container()
	_set_instruction_container()
	_set_card_text_container()


func _set_gold_gained_container() -> void:
	gold_gained_container = $GoldGainedContainer
	$GoldGainedContainer.size.x = MapSettings.play_space_size.x * 2.5
	$GoldGainedContainer.size.y = MapSettings.total_screen.y / 30
	$GoldGainedContainer/GoldGained.label_settings.font_size = (
		round(MapSettings.play_space_size.x) / 15
	)
	$GoldGainedContainer.position.x = MapSettings.total_screen.x - $GoldGainedContainer.size.x
	$GoldGainedContainer.position.y = (
		MapSettings.total_screen.y
		- MapSettings.resource_bar_size.y
		- MapSettings.end_turn_button_size.y
		- $GoldGainedContainer.size.y
	)
	update_gold_container_text(0, 1)


func _set_instruction_container() -> void:
	assert(gold_gained_container != null, "Gold Gained container size not set yet")
	$InstructionContainer.size.x = gold_gained_container.size.x
	$InstructionContainer.size.y = gold_gained_container.size.y * 6
	$InstructionContainer.position.x = MapSettings.total_screen.x - $InstructionContainer.size.x
	$InstructionContainer.position.y = (
		MapSettings.total_screen.y
		- MapSettings.resource_bar_size.y
		- MapSettings.end_turn_button_size.y
		- $GoldGainedContainer.size.y
		- $InstructionContainer.size.y
	)
	$InstructionContainer/InstructionText.label_settings = LabelSettings.new()
	$InstructionContainer/InstructionText.label_settings.font_size = (
		round(MapSettings.play_space_size.x) / 10
	)
	instruction_container = $InstructionContainer

	instruction_container.get_theme_stylebox("panel").set_border_width_all(
		instruction_container.size.x / 15
	)


func _set_card_text_container() -> void:
	assert(battle_zoom_preview != null, "ZoomPreview container size not set yet")
	card_text_container = $CardTextContainer
	battle_zoom_preview.card_text_container = card_text_container
	card_text_container.size.x = battle_zoom_preview.size.x
	card_text_container.size.y = battle_zoom_preview.size.y
	card_text_container.position.x = battle_zoom_preview.position.x
	card_text_container.position.y = battle_zoom_preview.position.y + battle_zoom_preview.size.y + card_text_container.size.y


@rpc("call_local")
func update_gold_container_text(gold_gained: int, turns_until_increase: int) -> void:
	if turns_until_increase == -1:
		$GoldGainedContainer/GoldGained.text = str("Gold gained: ", gold_gained)
	else:
		$GoldGainedContainer/GoldGained.text = str(
			"Gold gained: ", gold_gained, "\nTurns until increase: ", turns_until_increase
		)


func _tween_highlight_instruction_container() -> void:
	if !showing_instruction:
		return

	if highlight_instruction_container_tween:
		highlight_instruction_container_tween.kill()
	highlight_instruction_container_tween = create_tween()
	var ic_stylebox: StyleBox = instruction_container.get_theme_stylebox("panel")
	highlight_instruction_container_tween.tween_property(
		ic_stylebox, "border_color", Color("d75c27"), 1
	)
	highlight_instruction_container_tween.tween_callback(_tween_unhighlight_instruction_container)


func _tween_unhighlight_instruction_container() -> void:
	if !showing_instruction:
		return

	if highlight_instruction_container_tween:
		highlight_instruction_container_tween.kill()
	highlight_instruction_container_tween = create_tween()
	var ic_stylebox: StyleBox = instruction_container.get_theme_stylebox("panel")
	highlight_instruction_container_tween.tween_property(
		ic_stylebox, "border_color", Color("030000"), 1
	)
	highlight_instruction_container_tween.tween_callback(_tween_highlight_instruction_container)


func _tween_highlight_finish_button() -> void:
	if !showing_finish_button:
		return

	if highlight_finish_button_tween:
		highlight_finish_button_tween.kill()
	highlight_finish_button_tween = create_tween()
	var finish_button_stylebox: StyleBox = finish_button_container.get_theme_stylebox("panel")
	highlight_finish_button_tween.tween_property(
		finish_button_stylebox, "border_color", Color("d75c27"), 1
	)
	highlight_finish_button_tween.tween_callback(_tween_unhighlight_finish_button)


func _tween_unhighlight_finish_button() -> void:
	if !showing_finish_button:
		return

	if highlight_finish_button_tween:
		highlight_finish_button_tween.kill()
	highlight_finish_button_tween = create_tween()
	var finish_button_stylebox: StyleBox = finish_button_container.get_theme_stylebox("panel")
	highlight_finish_button_tween.tween_property(
		finish_button_stylebox, "border_color", Color("030000"), 1
	)
	highlight_finish_button_tween.tween_callback(_tween_highlight_finish_button)


func _on_end_turn_button_pressed():
	if Tutorial.next_phase == Tutorial.tutorial_phases.FINISH_TUTORIAL:
		Tutorial.continue_tutorial()
	if !GameManager.turn_manager.turn_actions_enabled:
		return

	GameManager.turn_manager.end_turn.rpc_id(1, GameManager.player_id)


func _on_resolve_spell_button_pressed():
	if GameManager.is_single_player:
		BattleSynchronizer.resolve_spell_agreed()
	if !GameManager.is_single_player:
		BattleSynchronizer.resolve_spell_agreed.rpc_id(
			GameManager.opposing_player_id(GameManager.player_id)
		)
	$ResolveSpellButton.hide()


func _input(_event):
	# If the game has ended we don't want to do anything with input
	if !GameManager.turn_manager:
		return
	if (
		Input.is_action_just_pressed("ui_accept")
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	):
		if Tutorial.is_awaiting_tutorial_input:
			Tutorial.continue_tutorial()
			return
		else:
			$TextBox.hide()

		if awaiting_input:
			Events.instruction_input_received.emit()
		if GameManager.turn_manager.can_start_turn:
			GameManager.turn_manager.can_start_turn = false
			if GameManager.is_single_player:
				GameManager.turn_manager.start_turn(GameManager.p1_id)
			if !GameManager.is_single_player:
				GameManager.turn_manager.start_turn.rpc_id(1, GameManager.player_id)


func _unhandled_input(event):
	if !GameManager.is_ready_to_play:
		return

	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and TargetSelection.can_drag_to_select
	):
		if event.pressed:
			TargetSelection.dragging_to_select = true
			TargetSelection.drag_start = event.position
		# If the mouse is released and is dragging, stop dragging
		elif TargetSelection.dragging_to_select:
			TargetSelection.clear_selections()
			TargetSelection.dragging_to_select = false
			queue_redraw()
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

			# Check if the selected area isn't too big
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
				# Add the spaces to selected spaces and check if at least one space is in range
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
					show_finish_button()
					for ps in TargetSelection.selected_spaces:
						ps.highlight_space()
				else:
					hide_finish_button()
					TargetSelection.clear_selections()

	elif event is InputEventMouseMotion and TargetSelection.dragging_to_select:
		queue_redraw()

	elif (
		event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	):
		TargetSelection.end_selecting()


func _draw():
	if TargetSelection.dragging_to_select:
		draw_rect(
			Rect2(
				TargetSelection.drag_start, get_global_mouse_position() - TargetSelection.drag_start
			),
			Color.YELLOW,
			false,
			2.0
		)


func _on_finish_button_pressed() -> void:
	Events.finish_button_pressed.emit()
	TargetSelection.space_selection_finished.emit()
	TargetSelection.target_selection_finished.emit()
	showing_finish_button = false
	$FinishButtonContainer.hide()
