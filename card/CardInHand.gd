extends PanelContainer

class_name CardInHand


var card_index: int = 1
var card_owner_id: int
var ingame_name: String
var card_type: int
var costs: Costs
var factions: Array = []
var attack: int
var health: int
var card_range: int
var movement: int
var border_style: StyleBox
var img_path: String
var card_text: String
var hand_index: int: get = _get_hand_index


func _ready():
	GameManager.cards_in_hand[card_owner_id].append(self)
	_load_card_properties()
	set_card_position()
	set_card_properties()
	set_card_size()
	_set_drag_node_properties()


func highlight_card():
	border_style = load("res://styling/card_borders/CardSelectedBorder.tres")
	add_theme_stylebox_override("panel", border_style)


func can_target_unit(card: CardInPlay) -> bool:
	if card_type == Collections.card_types.UNIT:
		return false

	if card:
		if card_range >= 0 and !card.current_play_space.in_play_range(card_range, card_owner_id):
			return false

	var can_target := false
	var target_restrictions = CardDatabase.cards_info[card_index]["TargetRestrictions"]

	if target_restrictions == TargetSelection.target_restrictions.ANY_SPACE:
		return true
	elif !card:
		return false

	match target_restrictions:
		TargetSelection.target_restrictions.ANY_UNITS:
			can_target = true
		TargetSelection.target_restrictions.OWN_UNITS:
			if card.card_owner_id == card_owner_id:
				can_target = true
		TargetSelection.target_restrictions.OPPONENT_UNITS:
			if card.card_owner_id != card_owner_id:
				can_target = true

	return can_target


func set_border():
	match len(factions):
		1:
			border_style = load(str(
				"res://styling/card_borders/", Collections.faction_names[factions[0]], "CardBorder.tres")
			)
			
		2:
			if Collections.factions.ANIMAL in factions and Collections.factions.MAGIC in factions:
				border_style = load(str("res://styling/card_borders/AnimalMagicBorder.tres"))
			if Collections.factions.ANIMAL in factions and Collections.factions.NATURE in factions:
				border_style = load(str("res://styling/card_borders/AnimalNatureBorder.tres"))
			if Collections.factions.ANIMAL in factions and Collections.factions.ROBOT in factions:
				border_style = load(str("res://styling/card_borders/AnimalRobotBorder.tres"))
			if Collections.factions.MAGIC in factions and Collections.factions.NATURE in factions:
				border_style = load(str("res://styling/card_borders/MagicNatureBorder.tres"))
			if Collections.factions.MAGIC in factions and Collections.factions.ROBOT in factions:
				border_style = load(str("res://styling/card_borders/MagicRobotBorder.tres"))
			if Collections.factions.NATURE in factions and Collections.factions.ROBOT in factions:
				border_style = load(str("res://styling/card_borders/NatureRobotBorder.tres"))
		_:
			border_style = load(str("res://styling/card_borders/MultiFactionCardBorder.tres"))
	
	add_theme_stylebox_override("panel", border_style)

	get_theme_stylebox("panel").border_width_left =  size.y / 10
	get_theme_stylebox("panel").border_width_right = size.y / 10
	get_theme_stylebox("panel").border_width_top = size.y / 10
	get_theme_stylebox("panel").border_width_bottom = size.y / 10


func set_card_position() -> void:
	position.x = GameManager.cards_in_hand[card_owner_id].find(self) * (
		((MapSettings.own_area_end.x - MapSettings.own_area_start.x) / 7)
	)
	
	match [GameManager.is_player_1, card_owner_id]:
		[true, GameManager.p1_id]:
			position.y = MapSettings.own_area_start.y
		[true, GameManager.p2_id]:
			position.y = MapSettings.opponent_area_start.y
		[false, GameManager.p2_id]:
			position.y = MapSettings.own_area_start.y
		[false, GameManager.p1_id]:
			position.y = MapSettings.opponent_area_start.y
		_:
			assert(
				false, str(
					"Unable to assert is_player_1 - card_owner_id combination. is_player_1: ",
					GameManager.battle_map.is_player_1(), 
					", card_owner_id: ", card_owner_id
					)
				)
		


func set_card_properties():
	$Vbox/TopInfo/CardNameBG/CardName.text = ingame_name
	_set_card_cost_visuals()
	
	if card_type == Collections.card_types.UNIT:
		$Vbox/BotInfo/BattleStats.text = str(attack, " / ", health)
		$Vbox/BotInfo/CardRange.text = str(movement)
	elif card_type == Collections.card_types.SPELL:
		$Vbox/BotInfo/BattleStats.hide()
		$Vbox/BotInfo/CardRange.text = str(card_range)
	
	set_border()


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


func set_card_size() -> void:
	scale.x *= ((MapSettings.own_area_end.x - MapSettings.own_area_start.x) / 7) / size.x
	scale.y *= (MapSettings.own_area_end.y - MapSettings.own_area_start.y) / size.y


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
		attack = card_info["Attack"]
		health = card_info["Health"]
		movement = card_info["Movement"]
	else:
		card_range = card_info["CardRange"]


func _set_drag_node_properties() -> void:
	$DragNode.img_path = img_path
	$DragNode.card_index = card_index
	$DragNode.card_in_hand = self
	$DragNode.card_owner_id = card_owner_id


func _on_mouse_entered():
	GameManager.zoom_preview.hover_zoom_preview_hand(self)


func _get_hand_index() -> int:
	return GameManager.cards_in_hand[card_owner_id].find(self)
