extends PanelContainer

class_name CardActionMenu

var action_button_scene := preload("res://card/CardActionMenuButton.tscn")
var cip_index: int
var card_owner_id: int


func _ready():
	_set_card_action_menu_buttons()


func _set_card_action_menu_buttons() -> void:
	var buttons_container := VBoxContainer.new()
	add_child(buttons_container)
	buttons_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var abilities: Array = GameManager.cards_in_play[card_owner_id][cip_index].abilities
	for b in range(len(abilities)):
		var action_button := action_button_scene.instantiate()
		action_button.cip_index = cip_index
		action_button.card_owner_id = card_owner_id
		action_button.func_text = abilities[b]["FuncText"]
		action_button.func_index = b
		action_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		buttons_container.add_child(action_button)
