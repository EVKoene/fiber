extends HBoxContainer

class_name DeckBuilderCard


@onready var border := StyleBoxFlat.new()
@onready var deck_builder = GameManager.deck_builder
@onready var n_label := $NLabel
@onready var starting_cards_label := $StartCardBox/NStartCards

@export var card_index: int = 1
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
	$CardContainer.get_theme_stylebox("panel").border_color = Styling.gold_color


func add_to_deck() -> void:
	if card_index in deck_builder.cards_in_deck.keys():
		deck_builder.cards_in_deck[card_index]["NCards"] += 1
		deck_builder.cards_in_deck[card_index]["Card"].set_n_label()
	else:
		deck_builder.add_new_card_to_deck(card_index)
	
	set_n_label()


func remove_from_deck() -> void:
	deck_builder.cards_in_deck[card_index]["NCards"] -= 1
	if card_index in deck_builder.starting_cards.keys():
		if deck_builder.starting_cards[card_index] > deck_builder.cards_in_deck[card_index]["NCards"]:
			deck_builder.remove_from_starting_cards(card_index)
	
	if deck_builder.cards_in_deck[card_index]["NCards"] == 0:
		queue_free()
		GameManager.deck_builder.cards_in_deck.erase(card_index)
	else:
		set_n_label()


func add_to_card_collection_options() -> void:
	if card_index in deck_builder.card_collection_options.keys():
		deck_builder.card_collection_options[card_index]["NCards"] += 1
		deck_builder.card_collection_options[card_index]["Card"].set_n_label()
	else:
		deck_builder.add_new_card_to_collection_options(card_index)

	set_n_label()


func remove_from_card_collection_options() -> void:
	deck_builder.card_collection_options[card_index]["NCards"] -= 1
	if deck_builder.card_collection_options[card_index]["NCards"] == 0:
		queue_free()
		GameManager.deck_builder.card_collection_options.erase(card_index)
	else:
		set_n_label()


func set_n_label() -> void:
	if is_in_deck:
		n_label.text = str(deck_builder.cards_in_deck[card_index]["NCards"])
	else:
		n_label.text = str(deck_builder.card_collection_options[card_index]["NCards"])


func set_card_properties():
	$CardContainer/Vbox/TopInfo/CardNameBG/CardName.text = ingame_name
	_set_card_cost_visuals()
	
	if card_type == Collections.card_types.UNIT:
		if max_attack == min_attack:
			$CardContainer/Vbox/BotInfo/BattleStats.text = str(max_attack, " / ", health)
		else:
			$CardContainer/Vbox/BotInfo/BattleStats.text = str(max_attack, "-", min_attack, " / ", health)
		$CardContainer/Vbox/BotInfo/CardRange.text = str(movement)
	elif card_type == Collections.card_types.SPELL:
		$CardContainer/Vbox/BotInfo/BattleStats.hide()
		$CardContainer/Vbox/BotInfo/CardRange.text = str(card_range)
	
	$CardContainer.get_theme_stylebox("panel").border_color = Styling.faction_colors[factions]
	
	if !is_in_deck:
		$StartCardBox/PlusButton.hide()
		$StartCardBox/NStartCards.hide()
		$StartCardBox/MinusButton.hide()


func _set_card_cost_visuals() -> void:
		if costs.animal > 0:
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Animal.show()
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Animal.text = str(
				costs.animal
			)
		else:
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Animal.hide()
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Animal.text = "0"
			
		if costs.magic > 0:
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Magic.show()
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Magic.text = str(
				costs.magic
			)
		else:
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Magic.hide()
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Magic.text = "0"

		if costs.nature > 0:
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Nature.show()
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Nature.text = str(
				costs.nature
			)
		else:
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Nature.hide()
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Nature.text = "0"
			
		if costs.robot > 0:
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Robot.show()
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Robot.text = str(
				costs.robot
			)
		else:
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Robot.hide()
			$CardContainer/Vbox/TopInfo/Costs/CostLabels/Robot.text = "0"


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
	if !$CardContainer/Vbox/TopInfo/CardNameBG/CardName.label_settings:
		$CardContainer/Vbox/TopInfo/CardNameBG/CardName.label_settings = LabelSettings.new()
	var min_font: float = round(size.x)/30
	var max_font: float = round(size.x)/20
	var max_chars := 30
	var font_range_diff: float = max_font - min_font
	var font_change_per_char: float = font_range_diff/(max_chars)
	var card_font_size: float
	card_font_size = (
		max_font - len(ingame_name) * font_change_per_char
	)
	
	$CardContainer/Vbox/TopInfo/CardNameBG/CardName.label_settings.font_size = card_font_size


func _add_border() -> void:
	$CardContainer.add_theme_stylebox_override("panel", border)

	border.set_border_width_all(int(size.y / 10))


func _on_plus_button_pressed():
	GameManager.deck_builder.add_to_starting_cards(card_index)


func _on_minus_button_pressed():
	GameManager.deck_builder.remove_from_starting_cards(card_index)


func _on_card_container_mouse_entered():
	GameManager.deck_builder.zoom_preview.preview_card_index(card_index, false)
	highlight_card()



func _on_card_container_mouse_exited():
	$CardContainer.get_theme_stylebox("panel").border_color = Styling.faction_colors[factions]


func _on_card_container_gui_input(event):
	if (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.pressed
	):
		if !is_in_deck:
			add_to_deck()
			remove_from_card_collection_options()
		elif is_in_deck:
			add_to_card_collection_options()
			remove_from_deck()
