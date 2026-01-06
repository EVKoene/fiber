extends Control

class_name Card

@onready var border := StyleBoxFlat.new()

var battle_stats: BattleStats
var card_class := -1
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

var column := -1
var row := -1


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



func highlight_stat(stat: int) -> void:
	match stat:
		Collections.stats.ATTACK_RANGE:
			$Vbox/BattleStatsContainer/AttackRange.highlight_stat()
		Collections.stats.HEALTH:
			$Vbox/BattleStatsContainer/DefenseBox/Health.highlight_stat()
		Collections.stats.MAX_ATTACK:
			$Vbox/BattleStatsContainer/AttackBox/MaxAttack.highlight_stat()
		Collections.stats.MIN_ATTACK:
			$Vbox/BattleStatsContainer/AttackBox/MinAttack.highlight_stat()
		Collections.stats.MOVEMENT:
			$Vbox/BattleStatsContainer/Movement.highlight_stat()
		Collections.stats.SHIELD:
			$Vbox/BattleStatsContainer/DefenseBox/Shield.highlight_stat()


func hide_stat_border(stat: int) -> void:
	match stat:
		Collections.stats.ATTACK_RANGE:
			$Vbox/BattleStatsContainer/AttackRange.hide_border()
		Collections.stats.HEALTH:
			$Vbox/BattleStatsContainer/DefenseBox/Health.hide_border()
		Collections.stats.MAX_ATTACK:
			$Vbox/BattleStatsContainer/AttackBox/MaxAttack.hide_border()
		Collections.stats.MIN_ATTACK:
			$Vbox/BattleStatsContainer/AttackBox/MinAttack.hide_border()
		Collections.stats.MOVEMENT:
			$Vbox/BattleStatsContainer/Movement.hide_border()
		Collections.stats.SHIELD:
			$Vbox/BattleStatsContainer/DefenseBox/Shield.hide_border()


func set_card_name() -> void:
	if !$Vbox/TopInfo/CardNameBG/CardName.label_settings:
		$Vbox/TopInfo/CardNameBG/CardName.label_settings = LabelSettings.new()
	var font_size: float
	font_size = round(size.x) / (
		len($Vbox/TopInfo/CardNameBG/CardName.text) * 0.1
	) * 0.04

	$Vbox/TopInfo/CardNameBG/CardName.label_settings.font_size = font_size
	$Vbox/TopInfo/CardNameBG/CardName.text = ingame_name


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
	
	if card_type == Collections.card_types.SPELL:
		set_card_range()
	else:
		_create_battle_stats()
	
	set_card_name()
	if !is_boss:
		set_cost_container()
	
	if card_class != Collections.card_classes.CARD_IN_HAND:
		set_card_image()


func _create_battle_stats() -> void:
	battle_stats = BattleStats.new(
		card_data["MaxAttack"],
		card_data["MinAttack"],
		card_data["Health"],
		card_data["Movement"],
		card_data["AttackRange"],
		self
	)
	
	set_battle_stats_containers()


func set_battle_stats_containers() -> void:
	battle_stats.attack_range_container = $Vbox/BattleStatsContainer/AttackRange
	battle_stats.health_container = $Vbox/BattleStatsContainer/DefenseBox/Health
	battle_stats.max_attack_container = $Vbox/BattleStatsContainer/AttackBox/MaxAttack
	battle_stats.min_attack_container = $Vbox/BattleStatsContainer/AttackBox/MinAttack
	battle_stats.shield_container = $Vbox/BattleStatsContainer/DefenseBox/Shield
	battle_stats.movement_container = $Vbox/BattleStatsContainer/Movement
	battle_stats.set_base_stats()


func set_card_range() -> void:
	if card_class != Collections.card_classes.CARD_IN_HAND:
		$Vbox/BattleStatsContainer.hide()
	
	$Vbox/CardRange.show()
	card_range = card_data["CardRange"]
	$Vbox/CardRange.update_stat(card_range)


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
			"Label": $Vbox/TopInfo/Costs/CostLabels/Passion,
			"Cost": costs.passion,
		},
		{
			"Label": $Vbox/TopInfo/Costs/CostLabels/Imagination,
			"Cost": costs.imagination,
		},
		{
			"Label": $Vbox/TopInfo/Costs/CostLabels/Growth,
			"Cost": costs.growth,
		},
		{
			"Label": $Vbox/TopInfo/Costs/CostLabels/Logic,
			"Cost": costs.logic,
		},
	]:
		f["Label"].text = str(f["Cost"])
		if f["Cost"] == 0:
			f["Label"].hide()
		else:
			f["Label"].show()
