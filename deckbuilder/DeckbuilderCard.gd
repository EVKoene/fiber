extends PanelContainer

class_name DeckBuilderCard


@onready var border := StyleBoxFlat.new()

var card_index: int = 1
var card_owner_id: int
var ingame_name: String
var card_type: int
var costs: Costs
var factions: Array = []
var max_attack: int
var min_attack: int
var health: int
var card_range: int
var movement: int
var border_style: StyleBox
var img_path: String
var card_text: String

var is_in_deck := false


func _ready():
	_load_card_properties()
	_add_border()
	set_card_properties()


func highlight_card():
	get_theme_stylebox("panel").border_color = Styling.gold_color


func set_card_properties():
	$Vbox/TopInfo/CardNameBG/CardName.text = ingame_name
	_set_card_cost_visuals()
	
	if card_type == Collections.card_types.UNIT:
		if max_attack == min_attack:
			$Vbox/BotInfo/BattleStats.text = str(max_attack, " / ", health)
		else:
			$Vbox/BotInfo/BattleStats.text = str(max_attack, "-", min_attack, " / ", health)
		$Vbox/BotInfo/CardRange.text = str(movement)
	elif card_type == Collections.card_types.SPELL:
		$Vbox/BotInfo/BattleStats.hide()
		$Vbox/BotInfo/CardRange.text = str(card_range)
	
	get_theme_stylebox("panel").border_color = Styling.faction_colors[factions]


func _set_card_cost_visuals() -> void:
		if costs.animal > 0:
			$Vbox/TopInfo/Costs/CostLabels/Animal.show()
			$Vbox/TopInfo/Costs/CostLabels/Animal.text = str(
				costs.animal
			)
		else:
			$Vbox/TopInfo/Costs/CostLabels/Animal.hide()
			$Vbox/TopInfo/Costs/CostLabels/Animal.text = "0"
			
		if costs.magic > 0:
			$Vbox/TopInfo/Costs/CostLabels/Magic.show()
			$Vbox/TopInfo/Costs/CostLabels/Magic.text = str(
				costs.magic
			)
		else:
			$Vbox/TopInfo/Costs/CostLabels/Magic.hide()
			$Vbox/TopInfo/Costs/CostLabels/Magic.text = "0"

		if costs.nature > 0:
			$Vbox/TopInfo/Costs/CostLabels/Nature.show()
			$Vbox/TopInfo/Costs/CostLabels/Nature.text = str(
				costs.nature
			)
		else:
			$Vbox/TopInfo/Costs/CostLabels/Nature.hide()
			$Vbox/TopInfo/Costs/CostLabels/Nature.text = "0"
			
		if costs.robot > 0:
			$Vbox/TopInfo/Costs/CostLabels/Robot.show()
			$Vbox/TopInfo/Costs/CostLabels/Robot.text = str(
				costs.robot
			)
		else:
			$Vbox/TopInfo/Costs/CostLabels/Robot.hide()
			$Vbox/TopInfo/Costs/CostLabels/Robot.text = "0"


func _load_card_properties() -> void:
	var card_info: Dictionary = CardDatabase.cards_info[card_index]
	
	ingame_name = card_info["InGameName"]
	img_path = card_info["IMGPath"]
	card_type = card_info["CardType"]
	factions = card_info["Factions"]
	card_text = card_info["Text"]

	costs = Costs.new(
		card_info["Costs"][Collections.factions.ANIMAL],
		card_info["Costs"][Collections.factions.MAGIC],
		card_info["Costs"][Collections.factions.NATURE],
		card_info["Costs"][Collections.factions.ROBOT]
	)

	if card_info["CardType"] == Collections.card_types.UNIT:
		max_attack = card_info["MaxAttack"]
		min_attack = card_info["MinAttack"]
		health = card_info["Health"]
		movement = card_info["Movement"]
	else:
		card_range = card_info["CardRange"]
	_set_card_text_font_size()


func _set_card_text_font_size() -> void:
	if !$Vbox/TopInfo/CardNameBG/CardName.label_settings:
		$Vbox/TopInfo/CardNameBG/CardName.label_settings = LabelSettings.new()
	var min_font: float = round(size.x)/20
	var max_font: float = round(size.x)/10
	var max_chars := 30
	var font_range_diff: float = max_font - min_font
	var font_change_per_char: float = font_range_diff/(max_chars)
	var card_font_size: float
	card_font_size = (
		max_font - len(ingame_name) * font_change_per_char
	)
	
	$Vbox/TopInfo/CardNameBG/CardName.label_settings.font_size = card_font_size


func _add_border() -> void:
	add_theme_stylebox_override("panel", border)

	border.set_border_width_all(int(size.y / 10))


func _on_mouse_entered():
	GameManager.deck_builder.zoom_preview.preview_card_index(card_index, false)
	highlight_card()


func _on_mouse_exited():
	get_theme_stylebox("panel").border_color = Styling.faction_colors[factions]


func _gui_input(event):
	if (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.pressed
	):
		if !is_in_deck:
			GameManager.deck_builder.add_to_deck(card_index)
		elif is_in_deck:
			GameManager.deck_builder.remove_from_deck(card_index)
