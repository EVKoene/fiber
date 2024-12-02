extends PanelContainer

class_name CardInHand


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
var hand_index: int: get = _get_hand_index


func _ready():
	GameManager.cards_in_hand[card_owner_id].append(self)
	_load_card_properties()
	set_card_position()
	_add_border()
	set_card_properties()
	set_card_size()
	_set_drag_node_properties()


func highlight_card():
	get_theme_stylebox("panel").border_color = Styling.gold_color


func discard() -> void:
	var h_index := hand_index
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_DISCARDED, null)
	if GameManager.is_single_player:
		BattleSynchronizer.remove_card_from_hand(card_owner_id, h_index)
	else:
		for p_id in GameManager.players:
			BattleSynchronizer.remove_card_from_hand.rpc_id(p_id, card_owner_id, h_index)
	Events.card_discarded.emit()


func play_spell(column: int, row: int) -> void:
	if GameManager.is_single_player:
		BattleSynchronizer.lock_zoom_preview_hand(card_owner_id, hand_index)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleSynchronizer.lock_zoom_preview_hand.rpc_id(p_id, card_owner_id, hand_index)
	
	GameManager.battle_map.create_card_resolve(card_owner_id, hand_index, column, row)


func can_target_unit(unit: CardInPlay) -> bool:
	if card_type == Collections.card_types.UNIT:
		return false

	if unit:
		if card_range >= 0 and !unit.current_play_space.in_play_range(card_range, card_owner_id):
			return false

	var can_target := false
	var target_restrictions = CardDatabase.cards_info[card_index]["TargetRestrictions"]

	if target_restrictions == TargetSelection.target_restrictions.ANY_SPACE:
		return true
	elif !unit:
		return false

	match target_restrictions:
		TargetSelection.target_restrictions.ANY_UNITS:
			can_target = true
		TargetSelection.target_restrictions.OWN_UNITS:
			if unit.card_owner_id == card_owner_id:
				can_target = true
		TargetSelection.target_restrictions.OPPONENT_UNITS:
			if unit.card_owner_id != card_owner_id:
				can_target = true

	return can_target


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
		if costs.passion > 0:
			$Vbox/TopInfo/Costs/CostLabels/Passion.show()
			$Vbox/TopInfo/Costs/CostLabels/Passion.text = str(
				costs.passion
			)
		else:
			$Vbox/TopInfo/Costs/CostLabels/Passion.hide()
			$Vbox/TopInfo/Costs/CostLabels/Passion.text = "0"
			
		if costs.imagination > 0:
			$Vbox/TopInfo/Costs/CostLabels/Imagination.show()
			$Vbox/TopInfo/Costs/CostLabels/Imagination.text = str(
				costs.imagination
			)
		else:
			$Vbox/TopInfo/Costs/CostLabels/Imagination.hide()
			$Vbox/TopInfo/Costs/CostLabels/Imagination.text = "0"

		if costs.growth > 0:
			$Vbox/TopInfo/Costs/CostLabels/Growth.show()
			$Vbox/TopInfo/Costs/CostLabels/Growth.text = str(
				costs.growth
			)
		else:
			$Vbox/TopInfo/Costs/CostLabels/Growth.hide()
			$Vbox/TopInfo/Costs/CostLabels/Growth.text = "0"
			
		if costs.logic > 0:
			$Vbox/TopInfo/Costs/CostLabels/Logic.show()
			$Vbox/TopInfo/Costs/CostLabels/Logic.text = str(
				costs.logic
			)
		else:
			$Vbox/TopInfo/Costs/CostLabels/Logic.hide()
			$Vbox/TopInfo/Costs/CostLabels/Logic.text = "0"


func set_card_size() -> void:
	scale.x *= MapSettings.card_in_hand_size.x / size.x
	scale.y *= MapSettings.card_in_hand_size.y / size.y


func _load_card_properties() -> void:
	var card_info: Dictionary = CardDatabase.cards_info[card_index]
	
	ingame_name = card_info["InGameName"]
	img_path = card_info["IMGPath"]
	card_type = card_info["CardType"]
	factions = card_info["Factions"]
	card_text = card_info["Text"]

	costs = Costs.new(
		card_info["Costs"][Collections.factions.PASSION],
		card_info["Costs"][Collections.factions.IMAGINATION],
		card_info["Costs"][Collections.factions.GROWTH],
		card_info["Costs"][Collections.factions.LOGIC]
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
	var min_font: float = round(MapSettings.play_space_size.x)/22
	var max_font: float = round(MapSettings.play_space_size.x)/13
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


func _set_drag_node_properties() -> void:
	$DragNode.img_path = img_path
	$DragNode.card_index = card_index
	$DragNode.card_in_hand = self
	$DragNode.card_owner_id = card_owner_id


func _on_mouse_entered():
	if Tutorial.next_phase == Tutorial.tutorial_phases.PREVIEW_CARD:
		GameManager.zoom_preview.preview_hand_card(self, true)
		Tutorial.continue_tutorial()
		return
	GameManager.zoom_preview.preview_hand_card(self, false)
	highlight_card()


func _on_mouse_exited():
	get_theme_stylebox("panel").border_color = Styling.faction_colors[factions]


func _gui_input(event):
	if (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.pressed
		and TargetSelection.discarding
	):
		discard()


func _get_hand_index() -> int:
	return GameManager.cards_in_hand[card_owner_id].find(self)
