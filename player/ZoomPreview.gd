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

var card_text_container: PanelContainer
var card_text_container_label: Label

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

	if card_type == Collections.card_types.UNIT:
		$VBox/BattleStatsContainer.show()
		$VBox/BattleStatsContainer.update_stat(Collections.stats.ATTACK_RANGE, card.attack_range)
		$VBox/BattleStatsContainer.update_stat(Collections.stats.HEALTH, card.health)
		$VBox/BattleStatsContainer.update_stat(Collections.stats.MAX_ATTACK, card.max_attack)
		$VBox/BattleStatsContainer.update_stat(Collections.stats.MIN_ATTACK, card.min_attack)
		$VBox/BattleStatsContainer.update_stat(Collections.stats.MOVEMENT, card.movement)
		$VBox/BattleStatsContainer.update_stat(Collections.stats.SHIELD, card.shield)
		
	else:
		$VBox/BattleStatsContainer.hide()
	
	$CardImage.show()
	$VBox.show()
	_set_costs_labels()
	_set_border_to_faction()
	$CardImage.texture = load(img_path)
	set_card_text(card.card_text)


func preview_card_in_play(card: CardInPlay, lock_card: bool) -> void:
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

	if card_type == Collections.card_types.UNIT:
		$VBox/BattleStatsContainer.show()
		$VBox/BattleStatsContainer.update_stat(Collections.stats.ATTACK_RANGE, card.battle_stats.attack_range)
		$VBox/BattleStatsContainer.update_stat(Collections.stats.HEALTH, card.battle_stats.health)
		$VBox/BattleStatsContainer.update_stat(Collections.stats.MAX_ATTACK, card.battle_stats.max_attack)
		$VBox/BattleStatsContainer.update_stat(Collections.stats.MIN_ATTACK, card.battle_stats.min_attack)
		$VBox/BattleStatsContainer.update_stat(Collections.stats.MOVEMENT, card.battle_stats.movement)
		$VBox/BattleStatsContainer.update_stat(Collections.stats.SHIELD, card.battle_stats.shield)
		
	else:
		$VBox/BattleStatsContainer.hide()

	$CardImage.show()
	$VBox.show()
	_set_costs_labels()
	_set_border_to_faction()
	$CardImage.texture = load(img_path)
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
		$VBox/BattleStatsContainer.show()
		$VBox/BattleStatsContainer.update_stat(Collections.stats.ATTACK_RANGE, card_data["AttackRange"])
		$VBox/BattleStatsContainer.update_stat(Collections.stats.MAX_ATTACK, card_data["MaxAttack"])
		$VBox/BattleStatsContainer.update_stat(Collections.stats.MIN_ATTACK, card_data["MinAttack"])
		$VBox/BattleStatsContainer.update_stat(Collections.stats.MOVEMENT, card_data["Movement"])
		$VBox/BattleStatsContainer.update_stat(Collections.stats.HEALTH, card_data["Health"])
		$VBox/BattleStatsContainer.update_stat(Collections.stats.SHIELD, 0)
	else:
		$VBox/BattleStatsContainer.hide()
	
	$CardImage.show()
	$VBox.show()
	_set_costs_labels()
	_set_border_to_faction()
	$CardImage.texture = load(img_path)
	set_card_text(card_data["CardText"])


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
	$VBox.hide()
	_set_costs_labels()
	get_theme_stylebox("panel").set_border_width_all(0)

	$CardImage.texture = null
	locked = false
	set_card_text("")


func set_card_text(card_text: String) -> void:
	_set_card_text_font_size(card_text)
	if len(card_text) == 0:
		card_text_container.hide()
	else:
		card_text_container.show()
	card_text_container_label.text = card_text


func _set_card_text_font_size(card_text: String) -> void:
	var min_font: float = round(card_text_container.size.x) / 25
	var max_font: float = round(card_text_container.size.x) / 19
	var max_line_count: float = 6
	var font_range_diff: float = max_font - min_font
	var font_change_per_line: float = font_range_diff / (max_line_count - 1)
	var card_text_font_size: float
	card_text_font_size = (max_font - CardHelper.calc_n_lines(card_text) * font_change_per_line)
	card_text_container_label.label_settings = LabelSettings.new()
	card_text_container_label.label_settings.font_size = card_text_font_size


func _set_container_sizes() -> void:
	$VBox/TopInfo/CardNameBG.custom_minimum_size.x = size.x * 0.6
	$VBox/TopInfo/CardNameBG.custom_minimum_size.y = size.y * 0.15
	$VBox/TopInfo/Costs.custom_minimum_size.x = size.x * 0.3


func _set_costs_labels() -> void:
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
	get_theme_stylebox("panel").border_color = Styling.faction_colors[fibers]


func _add_border() -> void:
	var border := StyleBoxFlat.new()
	add_theme_stylebox_override("panel", border)
	get_theme_stylebox("panel").set_border_width_all(size.y / 10)


func _add_cost_background() -> void:
	var background := StyleBoxFlat.new()
	$VBox/TopInfo/Costs.add_theme_stylebox_override("panel", background)
	background.set("bg_color", Color("bdbdbd"))
