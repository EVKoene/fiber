extends PanelContainer


class_name ZoomPreview

var attack: int
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
var max_font: int
var locked := false


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
		attack = card.attack
		health = card.health
		movement = card.movement
		card_range = 0
	else:
		card_range = card.card_range
		attack = 0
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
		attack = card.attack
		health = card.health
		movement = card.movement
		card_range = 0
	else:
		card_range = card.card_range
		attack = 0
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
		attack = card.attack
		health = card.health
		movement = card.movement
		card_range = 0
	else:
		card_range = card.card_range
		attack = 0
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
		attack = card.attack
		health = card.health
		movement = card.movement
		card_range = 0
	else:
		card_range = card.card_range
		attack = 0
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
	attack = 0
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
	_set_border_to_faction()
	_set_card_text_visuals()
	$CardImage.texture = null
	locked = false


func _set_labels() -> void:
	if card_type == Collections.card_types.UNIT:
		$VBox/BotInfo/Movement.text = str(movement)
		$VBox/BotInfo/BattleStats.text = str(attack, "/", health)
		$VBox/BotInfo/BattleStats.show()
	else:
		$VBox/BotInfo/Movement.text = str(card_range)
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
	match len(factions):   
		0:
			border_style = load(str(
				"res://styling/card_borders/NoBorder.tres"
			))
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
			max_font - float($VBox/BotInfo/CardText.get_line_count()) * font_change_per_line
		)
	
	$VBox/TopInfo/CardNameBG/CardName.label_settings.font_size = max_font
	$VBox/BotInfo/CardText.label_settings.font_size = card_text_font_size
