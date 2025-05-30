extends PanelContainer

class_name Card

@onready var border := StyleBoxFlat.new()

var card_data: Dictionary
var card_index: int = 1
var card_owner_id: int
var fabrication := false
var ingame_name: String
var card_type: int
var costs: Costs
var fibers: Array = []
var border_style: StyleBox
var card_text: String
var img_path: String


func highlight_card(_show_highlight: bool = false) -> void:
	border = StyleBoxFlat.new()
	add_theme_stylebox_override("panel", border)
	get_theme_stylebox("panel").border_color = Styling.gold_color
	get_theme_stylebox("panel").set_border_width_all(size.y / 11)
	add_theme_stylebox_override("panel", border)


func hide_border():
	remove_theme_stylebox_override("panel")


func set_card_name() -> void:
	if !$VBox/TopInfo/CardNameBG/CardName.label_settings:
		$VBox/TopInfo/CardNameBG/CardName.label_settings = LabelSettings.new()
	var font_size: float
	font_size = round(size.x) / (
		len($VBox/TopInfo/CardNameBG/CardName.text) * 0.05
	) * 0.04

	$VBox/TopInfo/CardNameBG/CardName.label_settings.font_size = font_size
	$VBox/TopInfo/CardNameBG/CardName.text = ingame_name


func load_card_properties() -> void:
	if !fabrication:
		card_data = CardDatabase.cards_info[card_index]
		ingame_name = card_data["InGameName"]
		card_type = card_data["CardType"]
		fibers = card_data["fibers"]
		card_text = card_data["Text"]
	set_card_image()
	set_card_name()


func set_card_image() -> void:
	img_path = card_data["IMGPath"]
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
