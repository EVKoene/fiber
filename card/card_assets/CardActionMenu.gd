extends PanelContainer

class_name CardActionMenu

var action_button_scene := preload("res://card/card_assets/CardActionMenuButton.tscn")
var cip_index: int
var card_owner_id: int
var card: CardInPlay

func _ready():
	card = GameManager.cards_in_play[card_owner_id][cip_index]
	_set_card_action_menu_buttons()


func _set_card_action_menu_buttons() -> void:
	var buttons_container := VBoxContainer.new()
	add_child(buttons_container)
	buttons_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var n_buttons := 0
	var abilities: Array = GameManager.cards_in_play[card_owner_id][cip_index].abilities
	for b in range(len(abilities)):
		var action_button := action_button_scene.instantiate()
		action_button.cip_index = cip_index
		action_button.card_owner_id = card_owner_id
		action_button.func_text = abilities[b]["FuncText"]
		action_button.func_index = n_buttons
		action_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		buttons_container.add_child(action_button)
		n_buttons += 1
	var play_space: PlaySpace = GameManager.ps_column_row[card.column][card.row]
	if (
		Collections.play_space_attributes.VICTORY_SPACE 
		in play_space.attributes
		and !card.fabrication
		and play_space.conquered_by != card_owner_id
	):
		var action_button := action_button_scene.instantiate()
		action_button.conquer_space = true
		action_button.cip_index = cip_index
		action_button.card_owner_id = card_owner_id
		action_button.func_text = "Conquer space"
		action_button.func_index = n_buttons
		action_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		buttons_container.add_child(action_button)
