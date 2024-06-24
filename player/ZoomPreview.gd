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


func set_zoom_preview(
	_attack: int,
	_health: int,
	_movement: int,
	_animal_cost: int,
	_magic_cost: int,
	_nature_cost: int,
	_robot_cost: int,
	_ingame_name: String,
	_card_type: int,
	_factions: Array,
	_card_text: String,
	_img_path: String,
	_card_range: int,
) -> void:
	attack = _attack
	health = _health
	movement = _movement
	animal_cost = _animal_cost
	magic_cost = _magic_cost
	nature_cost = _nature_cost
	robot_cost = _robot_cost
	ingame_name = _ingame_name
	card_type = _card_type
	factions = _factions
	card_text = _card_text
	img_path = _img_path
	card_range = _card_range
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


func _set_labels() -> void:
	$VBox/BotInfo/Movement.text = str(movement)
	$VBox/BotInfo/BattleStats.text = str(attack, "/", health)
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
			max_font - float($VBox/BotInfo/CardTextLabel.get_line_count()) * font_change_per_line
		)
	
	$VBox/TopInfo/CardNameBG/CardName.label_settings.font_size = max_font
	$VBox/BotInfo/CardText.label_settings.font_size = card_text_font_size
