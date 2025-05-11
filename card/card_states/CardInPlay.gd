extends Card

class_name CardInPlay

@onready var card_action_menu_scene := preload("res://card/card_assets/CardActionMenu.tscn")

var exhausted := false
var column := -1
var row := -1

var fabrication := false
var current_play_space: PlaySpace:
	get = _get_play_space
var card_data: Dictionary
var battle_stats: BattleStats
var lord: bool
var abilities: Array = []
var triggered_funcs: Array = []
var purposes: Array = []
var move_through_units := false
var card_in_play_index: int:
	get = _get_card_in_play_index


func _ready():
	scale *= MapSettings.card_in_play_size / size
	_load_card_properties()
	if !fabrication:
		_create_battle_stats()
		_create_costs()
	else:
		pass
	set_position_to_play_space()
	_set_cost_container()
	border.bg_color = Color(99999900)
	
	if (
		(GameManager.is_player_1 and card_owner_id == GameManager.p2_id)
		or (!GameManager.is_player_1 and card_owner_id == GameManager.p1_id)
	):
		flip_card()
	GameManager.ps_column_row[column][row].card_in_this_play_space = self
	if GameManager.is_server:
		BattleSynchronizer.call_deferred(
			"call_triggered_funcs", Collections.triggers.CARD_CREATED, self
		)
	_connect_signals()
	enter_battle.call_deferred()


func enter_battle() -> void:
	pass


func _connect_signals() -> void:
	# Override in card script to connect to signals on _ready
	pass


func is_ability_to_use_now() -> bool:
	# Override in card script to help AI decide if ability should be used
	return false


func resolve_ability_for_ai() -> void:
	# Override in card script to help AI use ability
	await get_tree().create_timer(0.25).timeout
	return


func prepare_attack() -> void:
	return


func attack_card(target_card: CardInPlay) -> void:
	prepare_attack()
	if (
		Tutorial.next_phase
		in [Tutorial.tutorial_phases.EXHAUST, Tutorial.tutorial_phases.CONQUER_VICTORY_SPACES]
	):
		Tutorial.continue_tutorial()
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.ATTACK, self)
	if GameManager.is_single_player:
		BattleAnimation.animate_attack(
			card_owner_id,
			card_in_play_index,
			target_card.current_play_space.direction_from_play_space(current_play_space)
		)
	if !GameManager.is_single_player:
		for p_id in [GameManager.p1_id, GameManager.p2_id]:
			BattleAnimation.animate_attack.rpc_id(
				p_id,
				card_owner_id,
				card_in_play_index,
				target_card.current_play_space.direction_from_play_space(current_play_space)
			)

	await deal_damage_to_card(target_card, int(randi_range(
		battle_stats.min_attack, battle_stats.max_attack
	)))
	await BattleSynchronizer.call_triggered_funcs(Collections.triggers.ATTACK_FINISHED, self)


func deal_damage_to_card(card: CardInPlay, value: int) -> void:
	await card.resolve_damage(value)


func select_card(show_select: bool) -> void:
	TargetSelection.selected_card = self
	TargetSelection.making_selection = true
	highlight_card(show_select)


func swap_with_card(swap_card_owner_id: int, swap_cip_index: int) -> void:
	var swap_card: CardInPlay = GameManager.cards_in_play[swap_card_owner_id][swap_cip_index]
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_MOVING_AWAY, self)
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_MOVING_AWAY, swap_card)
	if GameManager.is_single_player:
		BattleSynchronizer.swap_cards(
			card_owner_id, card_in_play_index, swap_card_owner_id, swap_cip_index
		)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleSynchronizer.swap_cards.rpc_id(
				p_id, card_owner_id, card_in_play_index, swap_card_owner_id, swap_cip_index
			)
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_MOVED, self)
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_MOVED, swap_card)


func move_to_play_space(new_column: int, new_row: int) -> void:
	if Tutorial.next_phase == Tutorial.tutorial_phases.ATTACK_CARD:
		Tutorial.continue_tutorial()
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_MOVING_AWAY, self)

	if GameManager.is_single_player:
		BattleSynchronizer.move_to_play_space(
			card_owner_id, card_in_play_index, new_column, new_row
		)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleSynchronizer.move_to_play_space.rpc_id(
				p_id, card_owner_id, card_in_play_index, new_column, new_row
			)

	await BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_MOVED, self)
	return


func move_over_path(path: PlaySpacePath) -> void:
	GameManager.turn_manager.set_turn_actions_enabled(false)

	TargetSelection.clear_arrows()
	TargetSelection.clear_arrows()
	if path.path_length > 0:
		for s in range(path.path_length):
			# We ignore the first playspace in path because it's the space the card is in. We
			# also ignore spaces the cards move trough. TODO: Animate moving through them.
			if s == 0:
				continue
			elif path.path_spaces[s].card_in_this_play_space and move_through_units:
				await get_tree().create_timer(0.1).timeout
				# We increase and decrease the z index to make sure the card will move over the card
				# it passes through
				z_index += 50
				position.x = path.path_spaces[s].position.x + MapSettings.play_space_size.x * 0.05
				position.y = path.path_spaces[s].position.y + MapSettings.play_space_size.y * 0.05
				z_index -= 50
			else:
				await get_tree().create_timer(0.1).timeout
				await move_to_play_space(path.path_spaces[s].column, path.path_spaces[s].row)

	TargetSelection.end_selecting()
	update_stats()
	GameManager.turn_manager.set_turn_actions_enabled(true)


func move_and_attack(target_card: CardInPlay) -> void:
	if current_play_space.distance_to_play_space(target_card.current_play_space, false) == 1:
		await attack_card(target_card)

	elif TargetSelection.current_path:
		if TargetSelection.current_path.last_space in spaces_in_range_to_melee_attack_card(target_card):
			await (move_over_path(TargetSelection.current_path))
			await attack_card(target_card)

	else:
		var spaces_to_attack_from: Array = spaces_in_range_to_melee_attack_card(target_card)
		if len(spaces_to_attack_from) == 0:
			assert(false, str(ingame_name, " tried to attack unit that is not in range"))
		var path_to_space: PlaySpacePath = current_play_space.find_play_space_path(
			spaces_to_attack_from.pick_random(), move_through_units
		)
		await (move_over_path(path_to_space))
		await attack_card(target_card)


func select_for_movement() -> void:
	TargetSelection.card_selected_for_movement = self
	TargetSelection.making_selection = true
	highlight_card(false)
	GameManager.zoom_preview.preview_card_in_play(self, true)


func refresh():
	if GameManager.is_single_player:
		BattleSynchronizer.refresh_unit(card_owner_id, card_in_play_index)
	if !GameManager.is_single_player:
		for p_id in [GameManager.p1_id, GameManager.p2_id]:
			BattleSynchronizer.refresh_unit.rpc_id(p_id, card_owner_id, card_in_play_index)


func exhaust():
	if GameManager.is_single_player:
		BattleSynchronizer.exhaust_unit(card_owner_id, card_in_play_index)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleSynchronizer.exhaust_unit.rpc_id(p_id, card_owner_id, card_in_play_index)


func use_ability(func_index: int) -> void:
	if call(abilities[func_index]["FuncName"]):
		GameManager.resources[card_owner_id].pay_costs(abilities[func_index]["AbilityCosts"])


func conquer_space() -> void:
	exhaust()
	current_play_space.add_to_territory(card_owner_id)
	for ps in current_play_space.adjacent_play_spaces():
		ps.add_to_territory(card_owner_id)
	current_play_space.set_conquered_by(card_owner_id)


func highlight_card(show_highlight: bool):
	if show_highlight:
		if GameManager.is_single_player:
			CardManipulation.highlight_card(card_owner_id, card_in_play_index)
		if !GameManager.is_single_player:
			for p_id in GameManager.players:
				CardManipulation.highlight_card.rpc_id(p_id, card_owner_id, card_in_play_index)
	else:
		border = StyleBoxFlat.new()
		add_theme_stylebox_override("panel", border)
		border.bg_color = Color(99999900)
		border.border_color = Styling.gold_color

		get_theme_stylebox("panel").set_border_width_all(size.y / 10)


func reset_card_stats():
	refresh()
	_load_card_properties()


func resolve_damage(value: int) -> void:
	var c_id := card_owner_id
	var cip_index := card_in_play_index
	if GameManager.is_single_player:
		await BattleSynchronizer.resolve_damage(c_id, cip_index, value)
	if !GameManager.is_single_player:
		for p_id in [GameManager.p1_id, GameManager.p2_id]:
			BattleSynchronizer.resolve_damage.rpc_id(p_id, c_id, cip_index, value)


func destroy() -> void:
	var cid := card_owner_id
	var cip_index := card_in_play_index
	if GameManager.is_single_player:
		CardManipulation.destroy(cid, cip_index)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			CardManipulation.destroy.rpc_id(p_id, cid, cip_index)


func shake() -> void:
	# Using the animation player for this might be better, but because we use texturerects
	# to make the image fit nicely it's a bit of a bother, and because we don't really use
	# collision moving the card instead of only animating range seems fine for now.
	position.x += 50
	await get_tree().create_timer(0.05).timeout
	position.x -= 50
	await get_tree().create_timer(0.05).timeout
	position.x += 30
	await get_tree().create_timer(0.05).timeout
	position.x -= 30
	await get_tree().create_timer(0.05).timeout

	position.x += 10
	await get_tree().create_timer(0.05).timeout
	position.x -= 10


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	for f in triggered_funcs:
		await TriggeredCardFuncs.call(
			f["FuncName"], self, trigger, triggering_card, f["FuncArguments"]
		)
	return


func spaces_in_range(range_to_check: int, ignore_obstacles := false) -> Array:
	var spaces: Array = []
	for ps in GameManager.play_spaces:
		var distance := current_play_space.distance_to_play_space(ps, ignore_obstacles)
		if distance == -1:
			continue
		elif distance <= range_to_check:
			spaces.append(ps)

	return spaces


func is_space_in_range_of_ranged_attack(target_ps: PlaySpace) -> bool:
	if (
		target_ps.row == current_play_space.row 
		and (abs(target_ps.column - current_play_space.column)) <= battle_stats.attack_range
	):
		return true
	
	if (
		target_ps.column == current_play_space.column
		and (abs(target_ps.row - current_play_space.row)) <= battle_stats.attack_range
	):
		return true
	
	return false

func spaces_in_range_to_melee_attack_card(card: CardInPlay) -> Array:
	"""Returns an array of spaces where self can attack card from"""
	var spaces_to_attack_from: Array = []
	for ps in card.current_play_space.adjacent_play_spaces():
		if ps.card_in_this_play_space:
			if ps.card_in_this_play_space != self:
				continue
		if ps in spaces_in_range(battle_stats.movement, false):
			spaces_to_attack_from.append(ps)

	return spaces_to_attack_from


func resolve_spell() -> bool:
	assert(
		false,
		str(
			"resolve spell not implemented for ",
			ingame_name,
			", function must be overriden in ",
			ingame_name,
			"script."
		)
	)
	return false


func hide_border():
	remove_theme_stylebox_override("panel")


func update_stats() -> void:
	battle_stats.update_all_stats()


func _set_cost_container() -> void:
	for f in [
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Passion,
			"Cost": costs.passion,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Imagination,
			"Cost": costs.imagination,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Growth,
			"Cost": costs.growth,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Logic,
			"Cost": costs.logic,
		},
	]:
		f["Label"].text = str(f["Cost"])
		if f["Cost"] == 0:
			f["Label"].hide()
		else:
			f["Label"].show()


func flip_card() -> void:
	$VBox.move_child($VBox/BattleStatsContainer, 0)
	$VBox/BattleStatsContainer.size_flags_vertical = SIZE_SHRINK_BEGIN
	$VBox/TopInfo.size_flags_vertical = SIZE_EXPAND | SIZE_SHRINK_END
	$CardImage.flip_v = true


func unflip_card() -> void:
	$VBox.move_child($VBox/BotInfo, 1)
	$VBox/TopInfo.size_flags_vertical = SIZE_SHRINK_BEGIN
	$VBox/BattleStatsContainer.size_flags_vertical = SIZE_EXPAND | SIZE_SHRINK_END
	$VBox/BattleStatsContainer.size_flags_vertical = SIZE_EXPAND | SIZE_SHRINK_END
	$CardImage.flip_v = false


func _is_resolve_spell_agreed() -> bool:
	Events.show_instructions.emit("Awaiting opponent agreement to spell resolve...")

	return true


@rpc("any_peer", "call_local")
func remove_from_cards_in_play() -> void:
	GameManager.cards_in_play[card_owner_id].remove_at(card_in_play_index)


func create_card_action_menu() -> void:
	var ca_menu := card_action_menu_scene.instantiate()
	TargetSelection.card_action_menu = ca_menu
	ca_menu.cip_index = card_in_play_index
	ca_menu.card_owner_id = card_owner_id
	ca_menu.position = position + MapSettings.play_space_size * 0.5
	ca_menu.size.x = MapSettings.play_space_size.x * 0.9
	ca_menu.size.y = MapSettings.play_space_size.y / (5 - len(abilities) + 1)
	ca_menu.z_index = 100
	GameManager.battle_map.add_child(ca_menu)


func _load_card_properties() -> void:
	if !fabrication:
		card_data = CardDatabase.cards_info[card_index]
		ingame_name = card_data["InGameName"]
		card_type = card_data["CardType"]
		fibers = card_data["fibers"]
		card_text = card_data["Text"]
		img_path = card_data["IMGPath"]
	$CardImage.texture = load(img_path)
	set_card_name()


func set_card_name() -> void:
	if !$VBox/TopInfo/CardNameBG/CardName.label_settings:
		$VBox/TopInfo/CardNameBG/CardName.label_settings = LabelSettings.new()
	var font_size: float
	font_size = round(MapSettings.play_space_size.x) / (
		len($VBox/TopInfo/CardNameBG/CardName.text) * 0.05
	) * 0.04

	$VBox/TopInfo/CardNameBG/CardName.label_settings.font_size = font_size
	$VBox/TopInfo/CardNameBG/CardName.text = ingame_name
	

func _set_card_text_visuals() -> void:
	_set_card_text_font_size()
	if len(card_text) <= 50:
		$VBox/BotInfo/CardText.custom_minimum_size.y = size.y * 0.2
	elif len(card_text) <= 100:
		$VBox/BotInfo/CardText.custom_minimum_size.y = size.y * 0.4
	else:
		$VBox/BotInfo/CardText.custom_minimum_size.y = size.y * 0.6

	if len(card_text) == 0:
		$VBox/BotInfo/CardText.hide()
	if len(card_text) > 0:
		$VBox/BotInfo/CardText.text = card_text
		$VBox/BotInfo/CardText.show()

	$VBox/TopInfo/CardNameBG/CardName.text = ingame_name


func _set_card_text_font_size() -> void:
	if !$VBox/BotInfo/CardText.label_settings:
		$VBox/BotInfo/CardText.label_settings = LabelSettings.new()
	var min_font: float = round(MapSettings.play_space_size.x) / 22
	var max_font: float = round(MapSettings.play_space_size.x) / 15
	var max_line_count: float = 6
	var font_range_diff: float = max_font - min_font
	var font_change_per_line: float = font_range_diff / (max_line_count - 1)
	var card_text_font_size: float
	if card_text == "":
		card_text_font_size = max_font
	else:
		card_text_font_size = (max_font - CardHelper.calc_n_lines(card_text) * font_change_per_line)

	$VBox/TopInfo/CardNameBG/CardName.label_settings.font_size = max_font
	$VBox/BotInfo/CardText.label_settings.font_size = card_text_font_size


func set_position_to_play_space() -> void:
	# TODO: Calculate an exact position while adjusting for the border
	position.x = MapSettings.get_column_start_x(column) + MapSettings.play_space_size.x * 0.05
	position.y = MapSettings.get_row_start_y(row) + MapSettings.play_space_size.y * 0.05
	z_index = current_play_space.z_index - 1


func _create_battle_stats() -> void:
	battle_stats = BattleStats.new(
		card_data["MaxAttack"],
		card_data["MinAttack"],
		card_data["Health"],
		card_data["Movement"],
		card_data["AttackRange"],
		self
	)
	
	battle_stats.battle_stats_container = $VBox/BattleStatsContainer
	battle_stats.set_base_stats()


func _create_costs() -> void:
	costs = Costs.new(
		card_data["Costs"][Collections.fibers.PASSION],
		card_data["Costs"][Collections.fibers.IMAGINATION],
		card_data["Costs"][Collections.fibers.GROWTH],
		card_data["Costs"][Collections.fibers.LOGIC],
		self
	)


func _get_play_space() -> PlaySpace:
	if column == -1:
		assert(false, "Column not set")
	if column == -1:
		assert(false, "Row not set")
	return GameManager.ps_column_row[column][row]


func _get_card_range() -> int:
	if "Range" in card_data.keys():
		return card_data["Range"]
	else:
		return -1


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if (
		GameManager.resources[data.card_owner_id].can_pay_costs(data.costs) 
		and data.card_type == Collections.card_types.SPELL
	):
		return true
	else:
		return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	data.play_spell(column, row)


func _on_mouse_entered():
	GameManager.zoom_preview.preview_card_in_play(self, false)

	if !TargetSelection.card_selected_for_movement:
		return
	if TargetSelection.card_selected_for_movement.card_owner_id == card_owner_id:
		return
	
	if (
		TargetSelection.play_space_selected_for_movement 
		in current_play_space.adjacent_play_spaces()
	):
		Input.set_custom_mouse_cursor(load("res://assets/CursorMiniAttackRed.png"))
	
	elif TargetSelection.card_selected_for_movement.is_space_in_range_of_ranged_attack(
		current_play_space
	):
		Input.set_custom_mouse_cursor(load("res://assets/RangedAttackPointer.png"))
	elif (
		TargetSelection.card_selected_for_movement.is_space_in_range_of_ranged_attack(
			current_play_space
		)
	):
		Input.set_custom_mouse_cursor(load("res://assets/CursorMiniAttackRed.png"))


func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)


func _on_gui_input(event):
	var left_mouse_button_pressed = (
		event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	)
	var right_mouse_button_pressed = (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_RIGHT
		and event.pressed
	)
	var card_sel_for_movement: CardInPlay = TargetSelection.card_selected_for_movement

	# These actions can be performed if the unit is exhausted (selecting the card for example)
	if (
		left_mouse_button_pressed
		and TargetSelection.selecting_spaces
		and current_play_space in TargetSelection.target_play_space_options
	):
		TargetSelection.selected_spaces.append(current_play_space)
		if len(TargetSelection.selected_spaces) == TargetSelection.number_of_spaces_to_select:
			TargetSelection.space_selection_finished.emit()

	elif (
		left_mouse_button_pressed
		and TargetSelection.number_of_targets_to_select > 0
		and current_play_space in TargetSelection.target_play_space_options
		and card_owner_id in TargetSelection.players_to_select_targets_from
		and self not in TargetSelection.selected_targets
		and (TargetSelection.self_allowed or TargetSelection.selecting_unit != self)
	):
		highlight_card(true)
		TargetSelection.selected_targets.append(self)
		if len(TargetSelection.selected_targets) == TargetSelection.number_of_targets_to_select:
			TargetSelection.target_selection_finished.emit()

	elif (
		left_mouse_button_pressed
		and GameManager.player_id == card_owner_id
		and TargetSelection.number_of_targets_to_select > 0
		and self in TargetSelection.selected_targets
	):
		TargetSelection.selected_targets.erase(self)
		if GameManager.is_single_player:
			CardManipulation.hide_border(card_owner_id, card_in_play_index)
		else:
			for p_id in [GameManager.p1_id, GameManager.p2_id]:
				CardManipulation.hide_border.rpc_id(
					p_id, card_owner_id, card_in_play_index
				)

	elif (
		left_mouse_button_pressed
		and GameManager.turn_manager.turn_owner_id == GameManager.player_id
		and !exhausted
		and GameManager.turn_manager.turn_actions_enabled
		and TargetSelection.card_selected_for_movement == self
	):
		TargetSelection.end_selecting()

	elif (
		left_mouse_button_pressed
		and GameManager.player_id == card_owner_id
		and GameManager.turn_manager.turn_owner_id == GameManager.player_id
		and !exhausted
		and GameManager.turn_manager.turn_actions_enabled
		and TargetSelection.card_selected_for_movement != self
	):
		TargetSelection.end_selecting()
		select_for_movement()

	# If the player selects a card for movement and clicks the card again we want to clear the
	# selections
	elif (
		left_mouse_button_pressed
		and card_sel_for_movement
		and card_owner_id == GameManager.player_id
	):
		if card_sel_for_movement == self and !exhausted:
			TargetSelection.end_selecting()

	elif (
		right_mouse_button_pressed
		and card_owner_id == GameManager.player_id
		and !exhausted
		and !card_sel_for_movement
		and (
			len(abilities) > 0
			or Collections.play_space_attributes.VICTORY_SPACE in current_play_space.attributes
		)
		and GameManager.turn_manager.turn_actions_enabled
		and GameManager.turn_manager.turn_owner_id == card_owner_id
	):
		TargetSelection.end_selecting()
		create_card_action_menu()

	elif (
		right_mouse_button_pressed
		and card_sel_for_movement
		and GameManager.turn_manager.turn_actions_enabled
		and card_owner_id != GameManager.player_id
	):
		var ps_to_attack_from = card_sel_for_movement.spaces_in_range_to_melee_attack_card(self)

		if (
			len(ps_to_attack_from) > 0
			and card_sel_for_movement.card_owner_id != card_owner_id
			and !TargetSelection.card_to_be_attacked
		):
			TargetSelection.card_to_be_attacked = self

		elif (
			card_sel_for_movement.card_owner_id != card_owner_id
			and TargetSelection.card_to_be_attacked == self
			and (
				TargetSelection.play_space_selected_for_movement 
				in current_play_space.adjacent_play_spaces()
			)
		):
			GameManager.turn_manager.set_turn_actions_enabled(false)

			card_sel_for_movement.move_and_attack(self)
			Input.set_custom_mouse_cursor(null)
			card_sel_for_movement.exhaust()
			TargetSelection.end_selecting()

			GameManager.turn_manager.set_turn_actions_enabled(true)

		elif (
			card_sel_for_movement.card_owner_id != card_owner_id
			and TargetSelection.card_to_be_attacked == self
			and card_sel_for_movement.is_space_in_range_of_ranged_attack(current_play_space)
		):
			GameManager.turn_manager.set_turn_actions_enabled(false)
			card_sel_for_movement.attack_card(self)
			Input.set_custom_mouse_cursor(null)
			card_sel_for_movement.exhaust()
			TargetSelection.end_selecting()
			GameManager.turn_manager.set_turn_actions_enabled(true)
		
		elif (
			card_sel_for_movement.card_owner_id != card_owner_id
			and TargetSelection.card_to_be_attacked == self
		):
			GameManager.turn_manager.set_turn_actions_enabled(false)

			card_sel_for_movement.move_and_attack(self)
			Input.set_custom_mouse_cursor(null)
			card_sel_for_movement.exhaust()
			TargetSelection.end_selecting()

			GameManager.turn_manager.set_turn_actions_enabled(true)

	elif (
		right_mouse_button_pressed
		and GameManager.turn_manager.turn_actions_enabled
		and TargetSelection.card_selected_for_movement
		and !TargetSelection.current_path
	):
		var card: CardInPlay = TargetSelection.card_selected_for_movement
		if card.move_through_units:
			var card_path = card.current_play_space.find_play_space_path(
				current_play_space, card.move_through_units
			)
			if card_path.path_length > 0 and card_path.path_length <= card.battle_stats.movement + 1:
				current_play_space.select_path_to_play_space(card_path)

	elif (
		right_mouse_button_pressed
		and GameManager.turn_manager.turn_actions_enabled
		and TargetSelection.card_selected_for_movement
		and TargetSelection.play_space_selected_for_movement != self
		and TargetSelection.current_path
	):
		if current_play_space in TargetSelection.current_path.path_spaces:
			TargetSelection.end_selecting()
		else:
			var card: CardInPlay = TargetSelection.card_selected_for_movement
			if card.move_through_units:
				TargetSelection.current_path.extend_path(current_play_space)


func _get_card_in_play_index() -> int:
	return GameManager.cards_in_play[card_owner_id].find(self)
