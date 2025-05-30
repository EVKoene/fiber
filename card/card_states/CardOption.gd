extends Panel

class_name CardOption

@onready var card_scene := load("res://card/card_states/Card.tscn")
@onready var card_text_container_scene := load("res://card/card_assets/CardTextContainer.tscn")

var battle_stats: BattleStats
var card: Card
var card_text_container: PanelContainer
var card_index: int
var card_owner_id: int
var card_text_label: Label
var vbox: VBoxContainer

var option_index: int
var card_pick_screen: CardPickScreen


func _ready():
	vbox = VBoxContainer.new()
	$CenterContainer.add_child(vbox)
	_setup_card()


func _setup_card() -> void:
	card = card_scene.instantiate()
	card_text_container = card_text_container_scene.instantiate()
	vbox.add_child(card)
	vbox.add_child(card_text_container)
	card.card_index = card_index
	card.load_card_properties()
	card.create_costs()
	card.set_cost_container()
	card.card_data = CardDatabase.cards_info[card_index]
	card.custom_minimum_size = MapSettings.card_in_play_size * 3
	card_text_container.custom_minimum_size.x = card.size.x
	card_text_container.size.x = card.size.x
	card_text_container.custom_minimum_size.y = card.size.y / 2
	card_text_container.size.y = card.size.y / 2
	card_text_container.set_card_text(card.card_data["Text"])
	
	card.connect("mouse_entered", highlight_card)
	card.connect("mouse_exited", unhighlight_card)
	card.connect("gui_input", pick)


func pick(event) -> void:
	if !(
		event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	if GameManager.is_single_player:
		BattleSynchronizer.pick_card(card_owner_id, option_index, card_pick_screen.card_indices)
	if !GameManager.is_single_player:
		BattleSynchronizer.pick_card.rpc_id(
			1, card_owner_id, option_index, card_pick_screen.card_indices
		)
	GameManager.turn_manager.set_turn_actions_enabled(true)
	card_pick_screen.queue_free()


func _create_battle_stats() -> void:
	battle_stats = BattleStats.new(
		card.card_data["MaxAttack"],
		card.card_data["MinAttack"],
		card.card_data["Health"],
		card.card_data["Movement"],
		card.card_data["AttackRange"],
		card
	)
	
	battle_stats.battle_stats_container = $VBox/BattleStatsContainer
	battle_stats.set_base_stats()


func _set_costs() -> void:
	for f in [
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Passion,
			"Cost": card.card_data["Costs"][Collections.fibers.PASSION],
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Imagination,
			"Cost": card.card_data["Costs"][Collections.fibers.IMAGINATION],
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Growth,
			"Cost": card.card_data["Costs"][Collections.fibers.GROWTH],
		},
		{
			"Label": $VBox/TopInfo/Costs/CostLabels/Logic,
			"Cost": card.card_data["Costs"][Collections.fibers.LOGIC],
		},
	]:
		f["Label"].text = str(f["Cost"])
		if f["Cost"] == 0:
			f["Label"].hide()
		else:
			f["Label"].show()


func _get_card_range() -> int:
	if "Range" in card.card_data.keys():
		return card.card_data["Range"]
	else:
		return -1


func highlight_card():
	card.highlight_card()


func unhighlight_card():
	card.hide_border()
