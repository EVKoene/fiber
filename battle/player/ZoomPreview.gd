extends PanelContainer


class_name ZoomPreview

var max_attack: int
var min_attack: int
var health: int
var movement: int
var passion_cost: int
var imagination_cost: int
var growth_cost: int
var logic_cost: int
var ingame_name: String
var card_type: int
var factions: Array
var card_text: String
var img_path: String
var card_range: int
var border_style: StyleBox
var locked := false


func _ready():
	_add_border()
	_set_container_sizes()
	_add_cost_background()


func preview_hand_card(
	card: CardInHand, lock_card: bool
) -> void:
	show()
	if locked and !lock_card:
		return
	
	locked = lock_card
	
	passion_cost = card.costs.passion
	imagination_cost = card.costs.imagination
	growth_cost = card.costs.growth
	logic_cost = card.costs.logic
	ingame_name = card.ingame_name
	card_type = card.card_type
	factions = card.factions
	card_text = card.card_text
	img_path = card.img_path
	
	if card_type == Collections.card_types.UNIT:
		max_attack = card.max_attack
		min_attack = card.min_attack
		health = card.health
		movement = card.movement
		card_range = 0
	else:
		card_range = card.card_range
		max_attack = 0
		min_attack = 0
		health = 0
		movement = 0
	
	if len(card_text) == 0:
		$VBox/BotInfo/CardText.hide()
	else:
		$VBox/BotInfo/CardText.show()
	$CardImage.show()
	$VBox.show()
	_set_labels()
	_set_border_to_faction()
	_set_card_text_visuals()
	$CardImage.texture = load(img_path)


func preview_card_in_play(
	card: CardInPlay, lock_card: bool
) -> void:
	show()
	if locked and !lock_card:
		return
	
	locked = lock_card
	
	passion_cost = card.costs.passion
	imagination_cost = card.costs.imagination
	growth_cost = card.costs.growth
	logic_cost = card.costs.logic
	ingame_name = card.ingame_name
	card_type = card.card_type
	factions = card.factions
	card_text = card.card_text
	img_path = card.img_path
	
	if card_type == Collections.card_types.UNIT:
		max_attack = card.max_attack
		min_attack = card.min_attack
		health = card.health
		movement = card.movement
		card_range = 0
	else:
		card_range = card.card_range
		max_attack = 0
		min_attack = 0
		health = 0
		movement = 0
	
	if len(card_text) == 0:
		$VBox/BotInfo/CardText.hide()
	else:
		$VBox/BotInfo/CardText.show()
	$CardImage.show()
	$VBox.show()
	_set_labels()
	_set_border_to_faction()
	_set_card_text_visuals()
	$CardImage.texture = load(img_path)


func preview_card_index(card_index, lock_card: bool) -> void:
	show()
	if locked and !lock_card:
		return
	
	locked = lock_card
	
	var card_data: Dictionary = CardDatabase.cards_info[card_index]
	passion_cost = card_data["Costs"][Collections.factions.PASSION]
	imagination_cost = card_data["Costs"][Collections.factions.IMAGINATION]
	growth_cost = card_data["Costs"][Collections.factions.GROWTH]
	logic_cost = card_data["Costs"][Collections.factions.LOGIC]
	ingame_name = card_data["InGameName"]
	card_type = card_data["CardType"]
	factions = card_data["Factions"]
	card_text = card_data["Text"]
	img_path = card_data["IMGPath"]
	
	if card_type == Collections.card_types.UNIT:
		max_attack = card_data["MaxAttack"]
		min_attack = card_data["MinAttack"]
		health = card_data["Health"]
		movement = card_data["Movement"]
		card_range = 0
	else:
		card_range = card_data["CardRange"]
		max_attack = 0
		min_attack = 0
		health = 0
		movement = 0
	
	if len(card_text) == 0:
		$VBox/BotInfo/CardText.hide()
	else:
		$VBox/BotInfo/CardText.show()
	$CardImage.show()
	$VBox.show()
	_set_labels()
	_set_border_to_faction()
	_set_card_text_visuals()
	$CardImage.texture = load(img_path)


func reset_zoom_preview() -> void:
	max_attack = 0
	min_attack = 0
	health = 0
	movement = 0
	passion_cost = 0
	imagination_cost = 0
	growth_cost = 0
	logic_cost = 0
	ingame_name = ""
	card_type = 0
	factions = []
	card_text = ""
	img_path = ""
	card_range = 0
	$CardImage.hide()
	$VBox.hide()
	_set_labels()
	get_theme_stylebox("panel").set_border_width_all(0)
	
	_set_card_text_visuals()
	$CardImage.texture = null
	locked = false


func _set_container_sizes() -> void:
	$VBox/TopInfo/CardNameBG.custom_minimum_size.x = size.x * 0.6
	$VBox/TopInfo/CardNameBG.custom_minimum_size.y = size.y * 0.15
	$VBox/BotInfo/CardText.custom_minimum_size.x = size.x * 0.6
	$VBox/TopInfo/Costs.custom_minimum_size.x = size.x * 0.3


func _set_labels() -> void:
	if card_type == Collections.card_types.UNIT:
		$VBox/BotInfo/Movement.text = str(movement)
		if max_attack == min_attack:
			$VBox/BotInfo/BattleStats.text = str(max_attack, "/", health)
		else:
			$VBox/BotInfo/BattleStats.text = str(max_attack, "-", min_attack, "/", health)
		$VBox/BotInfo/BattleStats.show()
	else:
		if card_range != -1:
			$VBox/BotInfo/Movement.text = str(card_range)
		else:
			$VBox/BotInfo/Movement.hide()
		$VBox/BotInfo/BattleStats.hide()
		
	for f in [
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Passion,
			"Cost": passion_cost,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Imagination,
			"Cost": imagination_cost,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Growth,
			"Cost": growth_cost,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Logic,
			"Cost": logic_cost,
		},
	]:
		f["Label"].text = str(f["Cost"])
		if f["Cost"] == 0:
			f["Label"].hide()
		else:
			f["Label"].show()


func _set_border_to_faction():
	get_theme_stylebox("panel").set_border_width_all(size.y / 10)
	get_theme_stylebox("panel").border_color = Styling.faction_colors[factions]


func _set_card_text_visuals() -> void:
	_set_card_text_font_size()
	$VBox/BotInfo/CardText.custom_minimum_size.x = size.x * 0.6
	if len(card_text) <= 50:
		$VBox/BotInfo/CardText.custom_minimum_size.y = size.y * 0.2
	elif len(card_text) <= 100:
		$VBox/BotInfo/CardText.custom_minimum_size.y = size.y * 0.4
	else:
		$VBox/BotInfo/CardText.custom_minimum_size.y = size.y * 0.6
	
	if len(card_text) > 0:
		$VBox/BotInfo/CardText.text = card_text
		$VBox/BotInfo/CardText.show()
	if len(card_text) == 0:
		$VBox/BotInfo/CardText.hide()
	$VBox/TopInfo/CardNameBG/CardName.text = ingame_name


func _set_card_text_font_size() -> void:
	var min_font: float = round(size.x)/25
	var max_font: float = round(size.x)/19
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
	$VBox/TopInfo/CardNameBG/CardName.label_settings = LabelSettings.new()
	$VBox/BotInfo/CardText.label_settings = LabelSettings.new()
	$VBox/BotInfo/Movement.label_settings = LabelSettings.new()
	$VBox/BotInfo/BattleStats.label_settings = LabelSettings.new()
	$VBox/TopInfo/CardNameBG/CardName.label_settings.font_size = max_font
	$VBox/BotInfo/CardText.label_settings.font_size = card_text_font_size
	$VBox/BotInfo/Movement.label_settings.font_size = max_font
	$VBox/BotInfo/BattleStats.label_settings.font_size = max_font
	
	for cost_label in [
		[$VBox/TopInfo/Costs/CostLabels/Passion, Collections.factions.PASSION],
		[$VBox/TopInfo/Costs/CostLabels/Imagination, Collections.factions.IMAGINATION],
		[$VBox/TopInfo/Costs/CostLabels/Growth, Collections.factions.GROWTH],
		[$VBox/TopInfo/Costs/CostLabels/Logic, Collections.factions.LOGIC],
	]:
		cost_label[0].label_settings = LabelSettings.new()
		cost_label[0].label_settings.font_size = max_font
		cost_label[0].label_settings.font_color = Styling.faction_colors[[cost_label[1]]]


func _add_border() -> void:
	var border := StyleBoxFlat.new()
	add_theme_stylebox_override("panel", border)
	get_theme_stylebox("panel").set_border_width_all(size.y / 10)


func _add_cost_background() -> void:
	var background := StyleBoxFlat.new()
	$VBox/TopInfo/Costs.add_theme_stylebox_override("panel", background)
	background.set("bg_color", Color("bdbdbd"))
