extends PanelContainer


class_name ZoomPreview

var max_attack: int
var min_attack: int
var health: int
var movement: int
var animal_cost: int
var magic_cost: int
var nature_cost: int
var robot_cost: int
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


func hover_zoom_preview_hand(
	card: CardInHand
) -> void:
	if locked:
		return
	animal_cost = card.costs.animal
	magic_cost = card.costs.magic
	nature_cost = card.costs.nature
	robot_cost = card.costs.robot
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


func hover_zoom_preview_play(
	card: CardInPlay
) -> void:
	if locked:
		return
	animal_cost = card.costs.animal
	magic_cost = card.costs.magic
	nature_cost = card.costs.nature
	robot_cost = card.costs.robot
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


func lock_zoom_preview_hand(
	card: CardInHand
) -> void:
	locked = true
	animal_cost = card.costs.animal
	magic_cost = card.costs.magic
	nature_cost = card.costs.nature
	robot_cost = card.costs.robot
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


func lock_zoom_preview_play(
	card: CardInPlay
) -> void:
	locked = true
	animal_cost = card.costs.animal
	magic_cost = card.costs.magic
	nature_cost = card.costs.nature
	robot_cost = card.costs.robot
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


func lock_from_card_index(card_index) -> void:
	var card_data: Dictionary = CardDatabase.cards_info[card_index]
	locked = true
	animal_cost = card_data["Costs"][Collections.factions.ANIMAL]
	magic_cost = card_data["Costs"][Collections.factions.MAGIC]
	nature_cost = card_data["Costs"][Collections.factions.NATURE]
	robot_cost = card_data["Costs"][Collections.factions.ROBOT]
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
	animal_cost = 0
	magic_cost = 0
	nature_cost = 0
	robot_cost = 0
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
			"Label": $VBox/TopInfo/Costs/CostLabels/Animal,
			"Cost": animal_cost,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Magic,
			"Cost": magic_cost,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Nature,
			"Cost": nature_cost,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Robot,
			"Cost": robot_cost,
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
	$VBox/TopInfo/CardNameBG/CardName.label_settings.font_size = max_font
	$VBox/BotInfo/CardText.label_settings.font_size = card_text_font_size
	
	for cost_label in [
		[$VBox/TopInfo/Costs/CostLabels/Animal, Collections.factions.ANIMAL],
		[$VBox/TopInfo/Costs/CostLabels/Magic, Collections.factions.MAGIC],
		[$VBox/TopInfo/Costs/CostLabels/Nature, Collections.factions.NATURE],
		[$VBox/TopInfo/Costs/CostLabels/Robot, Collections.factions.ROBOT],
	]:
		cost_label[0].label_settings = LabelSettings.new()
		cost_label[0].label_settings.font_color = Styling.faction_colors[[cost_label[1]]]
		cost_label[0].label_settings.font_size = max_font


func _add_border() -> void:
	var border := StyleBoxFlat.new()
	add_theme_stylebox_override("panel", border)
	get_theme_stylebox("panel").set_border_width_all(size.y / 10)
