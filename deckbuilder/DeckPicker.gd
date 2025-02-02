extends ScrollContainer

class_name DeckPicker

@onready var deck_pick_container_scene := load("res://deckbuilder/DeckPickContainer.tscn")
@onready var save_path := "user://savedata/"
@onready var collections_path := str(save_path, "collections.ini")
var decks = {}
var deck_nodes := []


# Called when the node enters the scene tree for the first time.
func _ready():
	find_decks()


func set_current_decks() -> void:
	for c in deck_nodes:
		c.queue_free()
	for d in decks:
		var dp_container = deck_pick_container_scene.instantiate()
		decks[d]["DPContainer"] = dp_container
		dp_container.deck_info = decks[d]
		dp_container.deck_id = decks[d]["ID"]
		dp_container.deck_picker = self
		deck_nodes.append(dp_container)
		$VBoxContainer.add_child(dp_container)


func find_decks() -> void:
	if !FileAccess.file_exists(collections_path):
		return
	var config := ConfigFile.new()
	config.load(collections_path)
	decks = config.get_value("deck_data", "decks", {})


func _on_new_deck_pressed():
	TransitionScene.transition_to_deck_builder(0)
	get_tree().paused = false


func _on_return_button_pressed():
	GameManager.current_scene.pause_menu.show_pause_menu()
