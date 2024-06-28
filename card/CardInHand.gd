extends PanelContainer

class_name CardInHand

@onready var card_scene: PackedScene = preload("res://card/CardInPlay.tscn")

@export var card_index: int = 1
@export var card_owner_id: int
@export var can_pay_costs: bool

#Note that the card_owner will only be set for the server
var card_owner: Player

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


func _ready():
	GameManager.cards_in_hand[card_owner_id].append(self)
	_load_card_properties()
	set_card_position()
	set_card_properties()
	set_card_size()
	_set_drag_node_properties()
	if GameManager.is_server:
		can_pay_costs = card_owner.resources.can_pay_costs(costs)


@rpc("any_peer")
func play_unit(column: int, row: int) -> void:
	var card: CardInPlay = card_scene.instantiate()
	var hand_index: int = GameManager.cards_in_hand[card_owner_id].find(self)
	card.set_script(CardDatabase.get_card_class(card_index))
	card.card_owner_id = card_owner_id
	card.card_index = card_index
	card.column = column
	card.row = row
	card_owner.cards_in_play.append(card)
	GameManager.resources[card_owner_id].pay_costs(costs)
	GameManager.battle_map.add_child(card, true)
	GameManager.zoom_preview.reset_zoom_preview()
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		GameManager.remove_card_from_hand.rpc_id(
			p_id, card_owner_id, hand_index)
		MultiPlayerManager.set_hand_card_positions.rpc_id(p_id)
	queue_free()


func highlight_card():
	border_style = load("res://styling/card_borders/CardSelectedBorder.tres")
	add_theme_stylebox_override("panel", border_style)


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
	GameManager.zoom_preview.hover_zoom_preview(
		attack, health, movement, costs.animal, costs.magic, costs.nature, costs.robot, ingame_name,
		card_type, factions, card_text, img_path, card_range
	)
