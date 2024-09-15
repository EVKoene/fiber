extends Node2D

@onready var play_space_scene: PackedScene = preload("res://map/play_space/PlaySpace.tscn")
@onready var card_scene: PackedScene = preload("res://card/card_states/CardInPlay.tscn")
@onready var resource_bar_scene: PackedScene = preload("res://player/ResourceBar.tscn")
@onready var turn_manager_scene: PackedScene = preload("res://manager/TurnManager.tscn")
@onready var card_pick_scene: PackedScene = preload("res://card/CardPickScreen.tscn")


var map = MapDatabase.maps.BASE_MAP
var map_data = MapDatabase.map_data[map]
var end_turn_button: Button
var instruction_container: PanelContainer
var text_box: Panel


func _ready():
	GameManager.battle_map = self
	$MultiplayerSpawner.add_spawnable_scene("res://manager/TurnManager.tscn")
	_create_battle_map()
	_set_zoom_preview_position_and_size()
	_set_end_turn_button()
	_set_finish_button()
	_set_resolve_spell_button()
	_set_resource_bars_position_and_size()
	_set_text_containers()
	_set_cards_in_play_and_hand_dicts()
	_create_progress_bars()
	_create_resources()
	_create_starting_territory()
	if multiplayer.is_server():
		GameManager.is_server = true
		_add_turn_managers()
		# To make sure the cards and card orders are always the same for both players, we only create
		# the decks on the server
		_add_decks()
		_start_first_turn()
	
	Events.show_instructions.connect(show_instructions)
	Events.hide_instructions.connect(hide_instructions)


@rpc("any_peer", "call_local")
func pick_card_option(card_indices: Array) -> void:
	var card_pick_screen := card_pick_scene.instantiate()
	card_pick_screen.card_indices = card_indices
	card_pick_screen.size = MapSettings.total_screen
	GameManager.battle_map.add_child(card_pick_screen)


func show_text(text_to_show: String) -> void:
	$TextBox/Panel/Label.text = text_to_show
	$TextBox.show()


func _start_first_turn() -> void:
	var first_player_id = [GameManager.p1_id, GameManager.p2_id].pick_random()
	GameManager.turn_manager.hide_end_turn_button.rpc_id(
		GameManager.opposing_player_id(first_player_id)
	)
	GameManager.turn_manager.show_start_turn_text.rpc_id(first_player_id)


func _add_decks() -> void:
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		var deck_data: Dictionary = GameManager.players[p_id]["Deck"]
		GameManager.decks[p_id] = Deck.new(p_id, deck_data["Cards"], deck_data["StartingCards"])
		add_child(GameManager.decks[p_id])


func _add_turn_managers() -> void:
	var turn_manager = turn_manager_scene.instantiate()
	add_child(turn_manager, true)


func _create_battle_map() -> void:
	MapSettings.n_progress_bars = map_data["SpacesToWin"]
	_set_area_sizes()
	_set_play_space_size()
	_create_play_spaces()
	

func _set_area_sizes() -> void:
	MapSettings.play_area_size = MapSettings.total_screen * Vector2(0.8, 0.9)
	MapSettings.opponent_area_start = Vector2(0, 0)
	MapSettings.opponent_area_end = Vector2(
		MapSettings.play_area_size.x, (
			MapSettings.total_screen.y - MapSettings.play_area_size.y
			) / 2
	)
	
	MapSettings.play_area_start = Vector2(0, (MapSettings.total_screen.y - MapSettings.play_area_size.y) / 2)
	MapSettings.play_area_end = Vector2(
		MapSettings.play_area_size.x, 
		MapSettings.play_area_size.y + (
			MapSettings.total_screen.y - MapSettings.play_area_size.y
		) / 2
	)
	
	MapSettings.own_area_start = Vector2(
		0, MapSettings.play_area_size.y + (
			MapSettings.total_screen.y - MapSettings.play_area_size.y
			) / 2
	)
	MapSettings.own_area_end = Vector2(MapSettings.play_area_size.x, MapSettings.total_screen.y)


func _set_play_space_size() -> void:
	var min_column_length: float = MapSettings.play_area_size.x / float(map_data["Columns"])
	var min_row_length: float = MapSettings.play_area_size.y / float(map_data["Rows"])
	
	var ps_size: int = min(min_column_length, min_row_length)

	MapSettings.play_space_size = Vector2(ps_size, ps_size)
	# TODO: Calculate an exact size based on borderwidth of playspace and card border
	MapSettings.card_in_play_size = Vector2(ps_size, ps_size) * 0.9
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


func _set_end_turn_button() -> void:
	$EndTurnButton.scale.x *= (MapSettings.total_screen.x / 10) / $EndTurnButton.size.x
	$EndTurnButton.scale.y *= (MapSettings.total_screen.y / 10) / $EndTurnButton.size.y
	$EndTurnButton.position.x = MapSettings.total_screen.x - MapSettings.total_screen.x / 10
	$EndTurnButton.position.y = MapSettings.total_screen.y - MapSettings.total_screen.y / 10
	MapSettings.end_turn_button_size = $EndTurnButton.size
	$EndTurnButton.text = "End your turn!"
	end_turn_button = $EndTurnButton


func hide_finish_button() -> void:
	$FinishButton.hide()


func show_finish_button() -> void:
	$FinishButton.show()


func _set_finish_button() -> void:
	var button = $FinishButton
	button.text = "Finish"
	button.custom_minimum_size.y = MapSettings.play_space_size.y / 2
	button.custom_minimum_size.x = MapSettings.play_space_size.x
	button.position.x = MapSettings.total_screen.x - MapSettings.play_space_size.x
	button.position.y = MapSettings.total_screen.y * 0.8


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
	$ZoomPreview.position.x = MapSettings.total_screen.x - zoom_preview_size.x * 1.05 
	$ZoomPreview.position.y = MapSettings.play_area_start.y
	$ZoomPreview.scale.x *= zoom_preview_size.x / $ZoomPreview.size.x
	$ZoomPreview.scale.y *= zoom_preview_size.x / $ZoomPreview.size.y
	MapSettings.zoom_preview_size = zoom_preview_size
	GameManager.zoom_preview = $ZoomPreview


func _set_resource_bars_position_and_size() -> void:
	var rb_1 = resource_bar_scene.instantiate()
	var rb_2 = resource_bar_scene.instantiate()
	
	match GameManager.is_player_1:
		true:
			rb_1.position.y = (
				MapSettings.total_screen.y - MapSettings.resource_bar_size.y 
				- MapSettings.end_turn_button_size.y
			)
			rb_2.position.y = 0
		false:
			rb_2.position.y = (
				MapSettings.total_screen.y - MapSettings.resource_bar_size.y 
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
			progress_bar.position.x = MapSettings.play_area_size.x + b * progress_bar_y_size
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
	$InstructionContainer.hide()


func show_instructions(instruction_text: String) -> void:
	$InstructionContainer/InstructionText.text = instruction_text
	$InstructionContainer.show()


func _set_text_containers() -> void:
	$InstructionContainer.size.x = (MapSettings.play_space_size.x * 2)
	$InstructionContainer.size.y = (MapSettings.total_screen.y / 5)
	$InstructionContainer.position.x = MapSettings.total_screen.x - MapSettings.play_space_size.x * 2
	$InstructionContainer.position.y = MapSettings.total_screen.y * 0.6
	$InstructionContainer/InstructionText.label_settings = LabelSettings.new()
	$InstructionContainer/InstructionText.label_settings.font_size = round(
		MapSettings.play_space_size.x
	)/15
	instruction_container = $InstructionContainer
	
	$TextBox.size = MapSettings.total_screen
	text_box = $TextBox
	_set_gold_gained_container()


func _set_gold_gained_container() -> void:
	assert(instruction_container.size.x > 0, "Instruction container size not set yet")
	$GoldGainedContainer.size.x = instruction_container.size.x
	$GoldGainedContainer.size.y = instruction_container.size.y / 6
	$GoldGainedContainer/GoldGained.label_settings.font_size = round(
		MapSettings.play_space_size.x
	)/15
	$GoldGainedContainer.position.x = MapSettings.total_screen.x - $GoldGainedContainer.size.x
	$GoldGainedContainer.position.y = MapSettings.total_screen.y * 0.8 - $GoldGainedContainer.size.y
	update_gold_container_text(0, 1)



func update_gold_container_text(gold_gained: int, turns_until_increase: int) -> void:
	if turns_until_increase == -1:
		$GoldGainedContainer/GoldGained.text = str("Gold gained: ", gold_gained)
	else:
		$GoldGainedContainer/GoldGained.text = str(
			"Gold gained: ", gold_gained, "\nTurns until increase: ", turns_until_increase
		)


func _set_cards_in_play_and_hand_dicts() -> void:
	GameManager.cards_in_hand[GameManager.p1_id] = []
	GameManager.cards_in_play[GameManager.p1_id] = []
	GameManager.cards_in_hand[GameManager.p2_id] = []
	GameManager.cards_in_play[GameManager.p2_id] = []


func _on_end_turn_button_pressed():
	if GameManager.turn_manager.turn_actions_enabled:
		GameManager.turn_manager.end_turn.rpc_id(GameManager.p1_id, GameManager.player_id)


func _on_finish_button_pressed():
	Events.finish_button_pressed.emit()
	TargetSelection.space_selection_finished.emit()
	TargetSelection.target_selection_finished.emit()
	$FinishButton.hide()


func _on_resolve_spell_button_pressed():
	MPManager.resolve_spell_agreed.rpc_id(
		GameManager.opposing_player_id(GameManager.player_id)
	)
	$ResolveSpellButton.hide()


func _create_resources():
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		var resources := Resources.new(p_id)
		GameManager.resources[p_id] = resources
		add_child(resources)


func _input(_event):
	if (
		(
			Input.is_action_just_pressed("ui_accept") 
			or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		)
		and GameManager.turn_manager.can_start_turn
	):
		GameManager.turn_manager.can_start_turn = false
		$TextBox.hide()
		GameManager.turn_manager.start_turn.rpc_id(GameManager.p1_id, GameManager.player_id)


func _unhandled_input(event):
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
			TargetSelection.select_rect.extents = abs(
				TargetSelection.drag_end - TargetSelection.drag_start
			) / 2
			for column in MapSettings.n_columns:
				if (
					MapSettings.get_column_end_x(column) >= TargetSelection.drag_start.x 
					and MapSettings.get_column_start_x(column) <= TargetSelection.drag_end.x
					and column not in TargetSelection.selected_columns
				) or (
					MapSettings.get_column_start_x(column) <= TargetSelection.drag_start.x 
					and MapSettings.get_column_end_x(column) >= TargetSelection.drag_end.x
					and column not in TargetSelection.selected_columns
				):
					TargetSelection.selected_columns.append(column)
			for row in MapSettings.n_rows:
				if (
					MapSettings.get_row_end_y(row) >= TargetSelection.drag_start.y 
					and MapSettings.get_row_start_y(row) <= TargetSelection.drag_end.y
					and row not in TargetSelection.selected_rows
				) or (
					MapSettings.get_row_start_y(row) <= TargetSelection.drag_start.y 
					and MapSettings.get_row_end_y(row) >= TargetSelection.drag_end.y
					and row not in TargetSelection.selected_rows
				):
					TargetSelection.selected_rows.append(row)
			
			# Check if the selected area isn't too big
			if (
				(
					len(TargetSelection.selected_columns) 
						<= TargetSelection.n_highest_axis_to_select
					and len(TargetSelection.selected_rows) 
						<= TargetSelection.n_lowest_axis_to_select
				)
				or (
						len(TargetSelection.selected_columns) 
						<= TargetSelection.n_lowest_axis_to_select
					and len(TargetSelection.selected_rows) 
						<= TargetSelection.n_highest_axis_to_select
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
					for ps in TargetSelection.selected_spaces:
						ps.highlight_space()
				else:
					TargetSelection.clear_selections()


	elif event is InputEventMouseMotion and TargetSelection.dragging_to_select:
		queue_redraw()
	
	elif (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.pressed
	):
		TargetSelection.end_selecting()


func _draw():
	if TargetSelection.dragging_to_select:
		draw_rect(
			Rect2(
				TargetSelection.drag_start, get_global_mouse_position() - TargetSelection.drag_start
			),
			Color.YELLOW, false, 2.0
		)
