extends PanelContainer

class_name CardOption


@export var card_index := 1
var max_attack: int
var min_attack: int
var health: int
var movement: int
var card_owner_id: int

var card_data: Dictionary

var ingame_name: String
var card_type: int
var factions: Array
var card_text: String
var battle_stats: BattleStats
var img_path: String
var card_range: int: get = _get_card_range
var border_style: StyleBox

var option_index: int
var card_pick_screen: CardPickScreen


func _ready():
	card_data = CardDatabase.cards_info[card_index]
	_set_costs()
	_load_card_properties()
	call_deferred("_add_border")


func pick() -> void:
	if GameManager.is_single_player:
		BattleManager.pick_card(card_owner_id, option_index, card_pick_screen.card_indices)
	if !GameManager.is_single_player:
		BattleManager.pick_card.rpc_id(
			1, card_owner_id, option_index, card_pick_screen.card_indices
		)
	GameManager.turn_manager.set_turn_actions_enabled(true)
	card_pick_screen.queue_free()


func _load_card_properties() -> void:
	ingame_name = card_data["InGameName"]
	card_type= card_data["CardType"]
	factions = card_data["Factions"]
	card_text = card_data["Text"]
	img_path = card_data["IMGPath"]
	
	if card_type == Collections.card_types.UNIT:
		max_attack = card_data["MaxAttack"]
		min_attack = card_data["MinAttack"]
		health = card_data["Health"]
		movement = card_data["Movement"]
	
	$CardImage.texture = load(img_path)
	_set_card_text_visuals()
	
	set_border_to_faction()


func set_border_to_faction():
	get_theme_stylebox("panel").border_color = Styling.faction_colors[factions]


func _set_labels() -> void:
	if card_type == Collections.card_types.SPELL:
		$VBox/BotInfo/BattleStats.hide()
		$VBox/BotInfo/Movement.hide()
	if card_type == Collections.card_types.UNIT:
		$VBox/BotInfo/Movement.text = str(movement)
		if max_attack == min_attack:
			$VBox/BotInfo/BattleStats.text = str(max_attack, "/", health)
		else:
			$VBox/BotInfo/BattleStats.text = str(max_attack, "-", min_attack,"/", health)



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
	_set_labels()


func _set_card_text_font_size() -> void:
	if !$VBox/BotInfo/CardText.label_settings:
		$VBox/BotInfo/CardText.label_settings = LabelSettings.new()
	var min_font: float = round(size.x)/22
	var max_font: float = round(size.x)/15
	var max_line_count: float = 6
	var font_range_diff: float = max_font - min_font
	var font_change_per_line: float = font_range_diff/(max_line_count - 1)
	var card_text_font_size: float
	if card_text == "":
		card_text_font_size = max_font
	else: 
		card_text_font_size = (
			max_font - CardHelper.calc_n_lines(card_text) * font_change_per_line
		)
	
	$VBox/TopInfo/CardNameBG/CardName.label_settings.font_size = max_font
	$VBox/BotInfo/CardText.label_settings.font_size = card_text_font_size


func _set_costs() -> void:
	for f in [
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Animal,
			"Cost": card_data["Costs"][Collections.factions.ANIMAL],
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Magic,
			"Cost": card_data["Costs"][Collections.factions.MAGIC],
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Nature,
			"Cost": card_data["Costs"][Collections.factions.NATURE],
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Robot,
			"Cost": card_data["Costs"][Collections.factions.ROBOT],
		},
	]:
		f["Label"].text = str(f["Cost"])
		if f["Cost"] == 0:
			f["Label"].hide()
		else:
			f["Label"].show()


func _get_card_range() -> int:
	if "Range" in card_data.keys():
		return card_data["Range"]
	else:
		return -1


func _add_border() -> void:
	var border := StyleBoxFlat.new()
	add_theme_stylebox_override("panel", border)

	get_theme_stylebox("panel").set_border_width_all(size.y / 10)
	get_theme_stylebox("panel").border_color = Styling.faction_colors[factions]


func _on_mouse_entered():
	get_theme_stylebox("panel").border_color = Styling.gold_color


func _on_mouse_exited():
	set_border_to_faction()


func _on_gui_input(event):
	if (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.pressed
	):
		pick()
