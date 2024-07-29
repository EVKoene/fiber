extends Button


class_name CardMenuActionButton

var cip_index: int
var card_owner_id: int
var func_text: String
var func_index: int
var conquer_space := false


func _ready():
	var label := Label.new()
	label.set_anchors_and_offsets_preset(Control.PRESET_HCENTER_WIDE)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var button_font_size: int = round(MapSettings.play_space_size.x)/15
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = button_font_size
	label.text = func_text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)


func _on_pressed():
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	if conquer_space:
		card.conquer_space()
		TargetSelection.end_selecting()
	elif GameManager.resources[card_owner_id].can_pay_costs(
		card.abilities[func_index]["AbilityCosts"]
	):
		card.use_ability(func_index)
		TargetSelection.clear_card_action_menu()
	else:
		TargetSelection.end_selecting()
