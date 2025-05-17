extends Control

class_name DeckBuilder

@onready var zoom_preview = $HBoxContainer/PanelContainer/DBZoomPreview
@onready var deck_builder_card_scene := preload("res://deckbuilder/DeckbuilderCard.tscn")
@onready var save_path := "user://savedata/"
@onready var collections_path := str(save_path, "collections.ini")

var current_deck: BuildDeck
var deck_name: String
var card_collection_options := {}
var cards_in_deck := {}
var starting_cards := {}
var n_selected_starting_cards := 0
var deck_id := 0
var is_saved := false


func _ready():
	GameManager.deck_builder = self
	GameManager.current_scene = self
	_set_zoom_preview_position_and_size()
	_setup_cards_from_card_collection()
	if deck_id != 0:
		_setup_existing_deck()


func _save_deck() -> void:
	var config := ConfigFile.new()
	config.load(collections_path)
	var decks: Dictionary = config.get_value("deck_data", "decks")
	if deck_id == 0:
		_set_deck_id(decks)
	if !deck_name:
		deck_name = "Custom deck " + str(deck_id)
	var cards := {}

	for card_index in cards_in_deck:
		cards[card_index] = cards_in_deck[card_index]["NCards"]

	if starting_cards == {}:
		starting_cards = {cards_in_deck.keys()[0]: 3}
	var deck := {
		"DeckName": deck_name,
		"Cards": cards,
		"StartingCards": starting_cards,
		"ID": deck_id,
	}

	decks[deck_id] = deck
	config.save(collections_path)
	is_saved = true


func add_new_card_to_deck(card_index: int) -> void:
	var db_card := deck_builder_card_scene.instantiate()

	cards_in_deck[card_index] = {}
	cards_in_deck[card_index]["NCards"] = 1
	cards_in_deck[card_index]["Card"] = db_card
	db_card.card_index = card_index
	db_card.is_in_deck = true
	$HBoxContainer/CardsInDeckScroller/CardsInDeck.add_child(db_card)


func add_new_card_to_collection_options(card_index: int) -> void:
	var db_card := deck_builder_card_scene.instantiate()

	card_collection_options[card_index] = {}
	card_collection_options[card_index]["NCards"] = 1
	card_collection_options[card_index]["Card"] = db_card
	db_card.card_index = card_index
	db_card.is_in_deck = false
	$HBoxContainer/FilteredCardsScroller/FilteredCards.add_child(db_card)


func add_to_starting_cards(card_index: int) -> void:
	if n_selected_starting_cards >= 3:
		return

	if card_index in starting_cards.keys():
		# We don't want the user to add more of a card as starting card than they have the card
		# currently in the deck, so we return if the number is equal
		if cards_in_deck[card_index]["NCards"] == starting_cards[card_index]:
			return
		starting_cards[card_index] += 1
	else:
		starting_cards[card_index] = 1

	n_selected_starting_cards += 1
	cards_in_deck[card_index]["Card"].starting_cards_label.text = str(starting_cards[card_index])


func remove_from_starting_cards(card_index: int) -> void:
	if card_index not in starting_cards.keys():
		return

	starting_cards[card_index] -= 1

	if starting_cards[card_index] == 0:
		cards_in_deck[card_index]["Card"].starting_cards_label.text = "0"
		starting_cards.erase(card_index)
	else:
		cards_in_deck[card_index]["Card"].starting_cards_label.text = str(
			starting_cards[card_index]
		)

	n_selected_starting_cards -= 1


func _setup_cards_from_card_collection() -> void:
	var config := ConfigFile.new()
	config.load(collections_path)
	var card_collection: Dictionary = config.get_value("card_collection", "cards")
	for c in card_collection:
		add_new_card_to_collection_options(c)
		for i in card_collection[c] - 1:
			card_collection_options[c]["Card"].add_to_card_collection_options()


func _setup_existing_deck() -> void:
	var config := ConfigFile.new()
	config.load(collections_path)
	var existing_deck: Dictionary = config.get_value("deck_data", "decks")[deck_id]
	for c in existing_deck["Cards"]:
		for i in existing_deck["Cards"][c]:
			card_collection_options[c]["Card"].add_to_deck()
			card_collection_options[c]["Card"].remove_from_card_collection_options()
	for s in existing_deck["StartingCards"]:
		for i in range(existing_deck["StartingCards"][s]):
			add_to_starting_cards(s)


func _set_deck_id(decks: Dictionary) -> void:
	#TODO: This is a "temporary" solution to create a new unique ID for each deck, but seems like
	# it would break quickly. We want all the decks the player makes to be 1000+ to seperate them
	# from the deckcollection that's already in the game
	if decks == {}:
		deck_id = 1
	else:
		var highest_deck_id := 0
		for d in decks:
			if decks[d]["ID"] > highest_deck_id:
				highest_deck_id = decks[d]["ID"]
		if highest_deck_id >= 1000:
			deck_id = highest_deck_id + 1
		else:
			deck_id = 1000


func _set_zoom_preview_position_and_size() -> void:
	var zoom_preview_size: Vector2 = Vector2(size.x * 0.3, size.x * 0.3)
	# Multiplying the zoom_preview_size.x with 1.1 to adjust for border size
	zoom_preview.position.x = MapSettings.total_screen.x - zoom_preview_size.x * 1.05
	zoom_preview.position.y = MapSettings.play_area_start.y
	zoom_preview.custom_minimum_size.x = zoom_preview_size.x
	zoom_preview.custom_minimum_size.y = zoom_preview_size.y
	$HBoxContainer/PanelContainer/CardTextContainer.custom_minimum_size.x = zoom_preview_size.x
	$HBoxContainer/PanelContainer/CardTextContainer.custom_minimum_size.y = zoom_preview_size.y / 2
	zoom_preview.card_text_container = $HBoxContainer/PanelContainer/CardTextContainer
	zoom_preview.card_text_container_label = $HBoxContainer/PanelContainer/CardTextContainer/CardTextContainerLabel
	zoom_preview.preview_card_index(1, false)
	

func _on_finish_button_pressed():
	if !is_saved:
		GameManager.main_menu.show_prompt(
			"Your deck has not been saved yet. Are you sure you want to quit?"
		)
		var prompt_answer_positive = await Events.prompt_answer_positive
		if !prompt_answer_positive:
			return

	TransitionScene.transition_to_overworld_scene(
		OverworldManager.saved_area_id, OverworldManager.saved_player_position
	)


func _on_save_button_pressed():
	_save_deck()


func _on_deck_name_input_text_changed():
	deck_name = $HBoxContainer/PanelContainer/DeckNameInput.text
