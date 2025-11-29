extends PanelContainer

class_name ZoomPreview

var attack_range: int
var card_range: int
var max_attack: int
var min_attack: int
var movement: int
var health: int
var shield: int

var passion_cost: int
var imagination_cost: int
var growth_cost: int
var logic_cost: int
var ingame_name: String
var card_type: int
var fibers: Array
var img_path: String
var border_style: StyleBox
var locked := false

var card_text_container: CardTextContainer

func _ready():
	_add_border()
	_set_container_sizes()
	_add_cost_background()


func preview_hand_card(card: CardInHand, lock_card: bool) -> void:
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
	fibers = card.fibers
	img_path = card.img_path

	if card_type in [Collections.card_types.UNIT, Collections.card_types.BOSS]:
		$BattleStats.show()
		$BattleStats/AttackRange.update_stat(card.attack_range)
		$BattleStats/Health.update_stat(card.health)
		$BattleStats/MaxAttack.update_stat(card.max_attack)
		$BattleStats/MinAttack.update_stat(card.min_attack)
		$BattleStats/Movement.update_stat(card.movement)
		$BattleStats/Shield.update_stat(card.shield)
		
	else:
		$CardRange.show()
		$CardRange.update_stat(card_range)
	
	$CardImage.show()
	_set_costs_labels()
	_set_border_to_faction()
	$CardImage.texture = load(img_path)
	set_card_text(card.card_text)


func preview_card_in_play(card: CardInPlay, lock_card: bool) -> void:
	show()
	if locked and !lock_card:
		return

	locked = lock_card
	
	if !card.is_boss:
		passion_cost = card.costs.passion
		imagination_cost = card.costs.imagination
		growth_cost = card.costs.growth
		logic_cost = card.costs.logic
	
	ingame_name = card.ingame_name
	card_type = card.card_type
	fibers = card.fibers
	img_path = card.img_path

	$BattleStats.show()
	$BattleStats/AttackRange.update_stat(card.battle_stats.attack_range)
	$BattleStats/Health.update_stat(card.battle_stats.health)
	$BattleStats/MaxAttack.update_stat(card.battle_stats.max_attack)
	$BattleStats/MinAttack.update_stat(card.battle_stats.min_attack)
	$BattleStats/Movement.update_stat(card.battle_stats.movement)
	$BattleStats/Shield.update_stat(card.battle_stats.shield)
	
	$CardImage.show()
	_set_costs_labels()
	_set_border_to_faction()
	$CardImage.texture = load(img_path)
	if card.is_boss:
		set_card_text(card.next_boss_ability["Text"])
	else:
		set_card_text(card.card_text)


func preview_card_index(card_index, lock_card: bool) -> void:
	show()
	if locked and !lock_card:
		return

	locked = lock_card

	var card_data: Dictionary = CardDatabase.cards_info[card_index]
	passion_cost = card_data["Costs"][Collections.fibers.PASSION]
	imagination_cost = card_data["Costs"][Collections.fibers.IMAGINATION]
	growth_cost = card_data["Costs"][Collections.fibers.GROWTH]
	logic_cost = card_data["Costs"][Collections.fibers.LOGIC]
	ingame_name = card_data["InGameName"]
	card_type = card_data["CardType"]
	fibers = card_data["fibers"]
	img_path = card_data["IMGPath"]

	if card_type == Collections.card_types.UNIT:
		$BattleStats.show()
		$BattleStats/AttackRange.update_stat(card_data["AttackRange"])
		$BattleStats/Health.update_stat(card_data["Health"])
		$BattleStats/MaxAttack.update_stat(card_data["MaxAttack"])
		$BattleStats/MinAttack.update_stat(card_data["MinAttack"])
		$BattleStats/Movement.update_stat(card_data["Movement"])
		$BattleStats/Shield.update_stat(0)
		
	else:
		$BattleStats.hide()
	
	$CardImage.show()
	_set_costs_labels()
	_set_border_to_faction()
	$CardImage.texture = load(img_path)
	set_card_text(card_data["Text"])


func reset_zoom_preview() -> void:
	passion_cost = 0
	imagination_cost = 0
	growth_cost = 0
	logic_cost = 0
	ingame_name = ""
	card_type = 0
	fibers = []
	img_path = ""
	$CardImage.hide()
	$TopInfo.hide()
	$BattleStats.hide()
	_set_costs_labels()
	get_theme_stylebox("panel").set_border_width_all(0)

	$CardImage.texture = null
	locked = false
	set_card_text("")


func set_card_text(card_text: String) -> void:
	$TopInfo/CardNameBG/CardName.text = ingame_name
	if len(card_text) == 0:
		card_text_container.hide()
	else:
		card_text_container.show()
	card_text_container.set_card_text(card_text)


func _set_container_sizes() -> void:
	$TopInfo/CardNameBG.custom_minimum_size.x = size.x * 0.6
	$TopInfo/CardNameBG.custom_minimum_size.y = size.y * 0.15
	$TopInfo/Costs.custom_minimum_size.x = size.x * 0.3


func _set_costs_labels() -> void:
	for f in [
		{
			"Label": $TopInfo/Costs/CostLabels/Passion,
			"Cost": passion_cost,
		},
		{
			"Label": $TopInfo/Costs/CostLabels/Imagination,
			"Cost": imagination_cost,
		},
		{
			"Label": $TopInfo/Costs/CostLabels/Growth,
			"Cost": growth_cost,
		},
		{
			"Label": $TopInfo/Costs/CostLabels/Logic,
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
	get_theme_stylebox("panel").border_color = Styling.faction_colors[fibers]


func _add_border() -> void:
	var border := StyleBoxFlat.new()
	add_theme_stylebox_override("panel", border)
	get_theme_stylebox("panel").set_border_width_all(size.y / 10)


func _add_cost_background() -> void:
	var background := StyleBoxFlat.new()
	$TopInfo/Costs.add_theme_stylebox_override("panel", background)
	background.set("bg_color", Color("bdbdbd"))
