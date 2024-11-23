extends HBoxContainer

class_name DeckPickContainer

@onready var deck_name_border := StyleBoxFlat.new()
@onready var save_path := "user://savedata/"
@onready var collections_path := str(save_path, "collections.ini")
var deck_info := {
	"DeckName": "DeckName"
}
var deck_id := 0
var deck_picker: DeckPicker


func _ready():
	$DeckNameContainer/DeckNameButton.text = deck_info["DeckName"]
	_add_deckname_border()


func _highlight_deckname() -> void:
	$DeckNameContainer.get_theme_stylebox("panel").border_color = Styling.gold_color


func _add_deckname_border() -> void:
	$DeckNameContainer.add_theme_stylebox_override("panel", deck_name_border)
	deck_name_border.set_border_width_all(int(size.y / 10))


func _on_deck_name_button_pressed():
	GameManager.set_current_deck(deck_id)


func _on_edit_button_pressed():
	TransitionScene.transition_to_deck_builder(deck_id)
	get_tree().paused = false


func _on_remove_button_pressed():
	var config := ConfigFile.new()
	config.load(collections_path)
	var updated_decks: Dictionary = config.get_value("deck_data", "decks")
	updated_decks.erase(deck_id)
	config.set_value("deck_data", "deck", updated_decks)
	deck_picker.set_current_decks()
