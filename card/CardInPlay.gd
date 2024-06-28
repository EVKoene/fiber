extends PanelContainer

class_name CardInPlay


@export var card_index := 1
@export var attack: int
@export var health: int
@export var movement: int
@export var exhausted := false
@export var card_owner_id: int
@export var column := -1
@export var row := -1
@export var fabrication := false


var current_play_space: PlaySpace: get = _get_play_space
var card_data: Dictionary
var battle_stats: BattleStats
var costs: Costs
var ingame_name: String
var card_type: int
var factions: Array
var lord: bool
var card_text: String
var img_path: String
var card_range: int: get = _get_card_range
var abilities: Array = []
var triggered_funcs: Array = []
var purposes: Array = []
var play_space: PlaySpace: get = _get_play_space
var border_style: StyleBox
var move_through_units := false
var max_font: int

func _ready():
	GameManager.cards_in_play[card_owner_id].append(self)
	_load_card_properties()
	_create_battle_stats()
	_create_costs()
	set_position_to_play_space()
	update_stats()
	if (
		(GameManager.is_player_1 and card_owner_id == GameManager.p2_id)
		or (!GameManager.is_player_1 and card_owner_id == GameManager.p1_id)
	):
		flip_card()
	scale *= MapSettings.card_in_play_size/size
	GameManager.ps_column_row[column][row].card_in_this_play_space = self


func move_to_play_space(new_column: int, new_row: int) -> void:
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		MultiPlayerManager.move_to_play_space.rpc_id(
			p_id, card_owner_id, GameManager.cards_in_play[card_owner_id].find(self), 
			new_column, new_row
		)


func move_over_path(path: PlaySpacePath) -> void:
	GameManager.turn_manager.turn_actions_enabled = false
	TargetSelection.clear_arrows()
	
	if path.path_length > 0:
		for s in range(path.path_length):
			# We ignore the first playspace in path because it's the space the card is in. We 
			# also ignore spaces the cards move trough. TODO: Animate moving through them.
			if s == 0:
				continue
			elif path.path_spaces[s].card_in_this_play_space and move_through_units:
				await get_tree().create_timer(0.25).timeout
				# We increase and decrease the z index to make sure the card will move over the card
				# it passes through
				z_index += 50
				position.x = path.path_spaces[s].position.x + MapSettings.play_space_size.x * 0.1
				position.y = path.path_spaces[s].position.y + MapSettings.play_space_size.y * 0.1
				z_index -= 50
			else:
				await get_tree().create_timer(0.25).timeout
				move_to_play_space(path.path_spaces[s].column, path.path_spaces[s].row)
			
	
	GameManager.turn_manager.turn_actions_enabled = true
	TargetSelection.end_selecting()
	


func select_for_movement() -> void:
	TargetSelection.card_selected_for_movement = self
	TargetSelection.making_selection = true
	highlight_card()
	GameManager.zoom_preview.lock_zoom_preview(
		attack,
		health,
		movement,
		costs.animal,
		costs.magic,
		costs.nature,
		costs.robot,
		ingame_name,
		card_type,
		factions,
		card_text,
		img_path,
		card_range
	)


func refresh():
	modulate = Color(1, 1, 1, 1)
	exhausted = false


func exhaust():
	modulate = Color(0.5, 0.5, 0.5, 1)
	exhausted = true


func highlight_card():
	border_style = load("res://styling/card_borders/CardSelectedBorder.tres")
	add_theme_stylebox_override("panel", border_style)


func reset_card_stats():
	refresh()
	_load_card_properties()
	update_stats()


func resolve_damage(damage) -> void:
	if damage > 0:
		shake()
	if !GameManager.is_server:
		return
	
	battle_stats.change_health(-damage, -1)
	update_stats()
	if health < 0:
		destroy()


func destroy() -> void:
	GameManager.cards_in_play[card_owner_id].erase(self)
	queue_free()


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
	await get_tree().create_timer(0.05).timeout
	
	
func update_stats() -> void:
	if GameManager.is_server:
		attack = battle_stats.attack
		health = battle_stats.health
		movement = battle_stats.movement
	_set_labels()


func _set_labels() -> void:
	$VBox/BotInfo/Movement.text = str(movement)
	$VBox/BotInfo/BattleStats.text = str(attack, "/", health)
	for f in [
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Animal,
			"Cost": costs.animal,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Magic,
			"Cost": costs.magic,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Nature,
			"Cost": costs.nature,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Robot,
			"Cost": costs.robot,
		},
	]:
		f["Label"].text = str(f["Cost"])
		if f["Cost"] == 0:
			f["Label"].hide()
		else:
			f["Label"].show()


func set_border_to_faction():
	match len(factions):   
		1:
			border_style = load(str(
				"res://styling/card_borders/", 
				Collections.faction_names[factions[0]], "CardBorder.tres"
			))
		2:
			if (
				Collections.factions.ANIMAL in factions 
				and Collections.factions.MAGIC in factions
			):
				border_style = load(str("res://styling/card_borders/AnimalMagicBorder.tres"))
			elif (
				Collections.factions.ANIMAL in factions 
				and Collections.factions.NATURE in factions
			):
				border_style = load(str("res://styling/card_borders/AnimalNatureBorder.tres"))
			elif (
				Collections.factions.ANIMAL in factions 
				and Collections.factions.ROBOT in factions
			):
				border_style = load(str("res://styling/card_borders/AnimalRobotBorder.tres"))
			elif (
				Collections.factions.MAGIC in factions 
				and Collections.factions.NATURE in factions
			):
				border_style = load(str("res://styling/card_borders/MagicNatureBorder.tres"))
			elif (
				Collections.factions.MAGIC in factions 
				and Collections.factions.ROBOT in factions
			):
				border_style = load(str("res://styling/card_borders/MagicRobotBorder.tres"))
			elif (
				Collections.factions.NATURE in factions 
				and Collections.factions.ROBOT in factions
			):
				border_style = load(str("res://styling/card_borders/NatureRobotBorder.tres"))
		_:
			border_style = load(str("res://styling/card_borders/MultiFactionCardBorder.tres"))
	
	add_theme_stylebox_override("panel", border_style)


func flip_card() -> void:
	$VBox.move_child($VBox/BotInfo, 0)
	$CardImage.flip_v = true
	$VBox/BotInfo.size_flags_vertical = SIZE_EXPAND | SIZE_SHRINK_BEGIN


func unflip_card() -> void:
	$VBox.move_child($VBox/BotInfo, 1)
	$VBox/TopInfo.size_flags_vertical = SIZE_SHRINK_BEGIN
	$CardImage.flip_v = false


func _load_card_properties() -> void:
	card_data = CardDatabase.cards_info[card_index]
	ingame_name = card_data["InGameName"]
	card_type= card_data["CardType"]
	factions = card_data["Factions"]
	lord = card_data["Lord"]
	card_text = card_data["Text"]
	img_path = card_data["IMGPath"]
	$CardImage.texture = load(img_path)
	_set_card_text_visuals()
	
	set_border_to_faction()


func _set_card_text_visuals() -> void:
	_set_card_text_font_size()
	if len(card_text) > 0:
		$VBox/BotInfo/CardText.text = card_text
		$VBox/BotInfo/CardText.show()
	if len(card_text) == 0:
		$VBox/BotInfo/CardText.hide()
	$VBox/TopInfo/CardNameBG/CardName.text = ingame_name


func _set_card_text_font_size() -> void:
	var min_font: int
	max_font = round(MapSettings.play_space_size.x)/15
	min_font = round(MapSettings.play_space_size.x)/30
	var max_line_count: float = 6
	var font_range_diff: float = max_font - min_font
	var font_change_per_line: float = font_range_diff/(max_line_count - 1)
	var card_text_font_size: float
	if card_text == "":
		card_text_font_size = max_font
	else: 
		card_text_font_size = (
			max_font - float($VBox/BotInfo/CardTextLabel.get_line_count()) * font_change_per_line
		)
	
	$VBox/TopInfo/CardNameBG/CardName.label_settings.font_size = max_font
	$VBox/BotInfo/CardText.label_settings.font_size = card_text_font_size


func set_position_to_play_space() -> void:
	position.x = MapSettings.get_column_start_x(column) + MapSettings.play_space_size.x * 0.1
	position.y = MapSettings.get_row_start_y(row) + MapSettings.play_space_size.y * 0.1
	z_index = play_space.z_index - 1


func _create_battle_stats() -> void:
	if !GameManager.is_server:
		return
	
	battle_stats = BattleStats.new(
		card_data["Attack"],
		card_data["Health"],
		card_data["Movement"],
		self
	)

func _create_costs() -> void:
	costs = Costs.new(
		card_data["Costs"][Collections.factions.ANIMAL],
		card_data["Costs"][Collections.factions.MAGIC],
		card_data["Costs"][Collections.factions.NATURE],
		card_data["Costs"][Collections.factions.ROBOT]
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


func _on_gui_input(event):
	var left_mouse_button_pressed = (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.pressed
	)
	
	if (
		left_mouse_button_pressed 
		and TargetSelection.number_of_targets_to_select > 0
		and self not in TargetSelection.selected_targets
	):
		highlight_card()
		TargetSelection.selected_cards.append(self)

	elif (
		left_mouse_button_pressed 
		and TargetSelection.number_of_targets_to_select > 0
		and self in TargetSelection.selected_targets
	):
		TargetSelection.selected_targets.erase(self)

	elif (
		left_mouse_button_pressed 
		and GameManager.turn_manager.turn_owner_id == GameManager.player_id
		and !exhausted
		and GameManager.turn_manager.turn_actions_enabled
		and TargetSelection.card_selected_for_movement == self
	):
		TargetSelection.clear_selections()
	
	elif (
		left_mouse_button_pressed 
		and GameManager.turn_manager.turn_owner_id == GameManager.player_id
		and !exhausted
		and GameManager.turn_manager.turn_actions_enabled
		and TargetSelection.card_selected_for_movement != self
	):
		TargetSelection.clear_selections()
		select_for_movement()
	
