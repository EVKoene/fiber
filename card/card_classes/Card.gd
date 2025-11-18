extends PanelContainer

class_name Card

@onready var border := StyleBoxFlat.new()

var battle_stats: BattleStats
var card_class: int
var card_data: Dictionary
var card_index: int = 1
var is_boss := false
var card_owner_id: int
var fabrication := false
var has_border := false
var ingame_name: String
var card_type: int
var costs: Costs
var fibers: Array = []
var border_style: StyleBox
var card_text: String
var img_path: String
var card_range: int


func highlight_card(_show_highlight: bool = false) -> void:
	if has_border:
		return
	
	has_border = true
	
	if card_class == Collections.card_classes.CARD_IN_HAND:
		modulate = Color(1, 1, 1, 1.5)
		return
	
	else:
		border.border_color = Styling.gold_color
		var border_width := size.x * 0.1
		border.set_border_width_all(border_width)
		border.set_content_margin_all(1)
		border.set_expand_margin_all(border_width)
		add_theme_stylebox_override("panel", border)


func hide_border():
	if !has_border:
		return
	
	has_border = false
	
	if card_class == Collections.card_classes.CARD_IN_HAND:
		modulate = Color(1, 1, 1, 1)
		return
	
	else:
		remove_theme_stylebox_override("panel")


func set_card_name() -> void:
	if !$VBox/TopInfo/CardNameBG/CardName.label_settings:
		$VBox/TopInfo/CardNameBG/CardName.label_settings = LabelSettings.new()
	var font_size: float
	font_size = round(size.x) / (
		len($VBox/TopInfo/CardNameBG/CardName.text) * 0.1
	) * 0.04

	$VBox/TopInfo/CardNameBG/CardName.label_settings.font_size = font_size
	$VBox/TopInfo/CardNameBG/CardName.text = ingame_name


func load_card_properties() -> void:
	if !is_boss and !fabrication:
		card_data = CardDatabase.cards_info[card_index]
		img_path = card_data["IMGPath"]
		ingame_name = card_data["InGameName"]
		card_type = card_data["CardType"]
		fibers = card_data["fibers"]
		card_text = card_data["Text"]
	
		create_costs()
	
	if is_boss:
		card_data = BossCardDatabase.boss_cards_info[card_index]
		img_path = card_data["IMGPath"]
		ingame_name = card_data["InGameName"]
		card_type = Collections.card_types.BOSS
		fibers = card_data["fibers"]
	
	match card_class:
		Collections.card_classes.CARD_IN_HAND:
			if card_type == Collections.card_types.UNIT:
				$VBox/BattleStatsContainer.hide()
			else:
				set_card_range()
	
		Collections.card_classes.CARD_OPTION:
			set_card_image()
			if card_type == Collections.card_types.SPELL:
				set_card_range()
			else:
				_create_battle_stats()
		_:
			set_card_image()
			if card_type in [Collections.card_types.UNIT, Collections.card_types.BOSS]:
				_create_battle_stats()
	
	set_card_name()
	if !is_boss:
		set_cost_container()


func _create_battle_stats() -> void:
	battle_stats = BattleStats.new(
		card_data["MaxAttack"],
		card_data["MinAttack"],
		card_data["Health"],
		card_data["Movement"],
		card_data["AttackRange"],
		self
	)
	
	battle_stats.battle_stats_container = $VBox/BattleStatsContainer
	battle_stats.set_base_stats()


func set_card_range() -> void:
	for child in $VBox/BattleStatsContainer/HBoxContainer.get_children():
		child.hide()
	
	$VBox/BattleStatsContainer/HBoxContainer/AttackRangeContainer.show()
	card_range = card_data["CardRange"]
	$VBox/BattleStatsContainer/HBoxContainer/AttackRangeContainer/AttackRangeLabel.text = str(
		card_range
	)


func set_card_image() -> void:
	$CardImage.texture = load(img_path)


func create_costs() -> void:
	costs = Costs.new(
		card_data["Costs"][Collections.fibers.PASSION],
		card_data["Costs"][Collections.fibers.IMAGINATION],
		card_data["Costs"][Collections.fibers.GROWTH],
		card_data["Costs"][Collections.fibers.LOGIC],
		self
	)


func set_cost_container() -> void:
	for f in [
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Passion,
			"Cost": costs.passion,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Imagination,
			"Cost": costs.imagination,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Growth,
			"Cost": costs.growth,
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Logic,
			"Cost": costs.logic,
		},
	]:
		f["Label"].text = str(f["Cost"])
		if f["Cost"] == 0:
			f["Label"].hide()
		else:
			f["Label"].show()
