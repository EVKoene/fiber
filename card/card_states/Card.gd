extends PanelContainer


class_name Card

@onready var border := StyleBoxFlat.new()

var card_index: int = 1
var card_owner_id: int
var ingame_name: String
var card_type: int
var costs: Costs
var fibers: Array = []
var max_attack: int
var min_attack: int
var health: int
var card_range: int
var movement: int
var border_style: StyleBox
var card_text: String
var img_path: String
