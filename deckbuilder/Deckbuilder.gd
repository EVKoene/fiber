extends Control


class_name DeckBuilder

@onready var zoom_preview = $HBoxContainer/PanelContainer/ZoomPreview
@onready var deck_builder_card_scene := preload("res://deckbuilder/DeckbuilderCard.tscn")
var current_deck: BuildDeck
var deck_name: String
var card_collection_options := {}
var cards_in_deck := {}


func _ready():
	GameManager.deck_builder = self
	zoom_preview.preview_card_index(1, false)
	_set_zoom_preview_position_and_size()
	_setup_cards_from_card_collection()


func add_to_deck(card_index: int) -> void:
	if card_index in cards_in_deck.keys():
		cards_in_deck[card_index]["NCards"] += 1
		cards_in_deck[card_index]["Label"].text = str(cards_in_deck[card_index]["NCards"])
	else:
		_add_new_card_to_deck(card_index)
	
	remove_from_collection_options(card_index)
	


func _add_new_card_to_deck(card_index: int) -> void:
	var hbox_container := HBoxContainer.new()
	var n_label := Label.new()
	var card := deck_builder_card_scene.instantiate()
	
	n_label.text = "1"
	card.card_index = card_index
	card.is_in_deck = true
	hbox_container.size_flags_horizontal = 4
	$HBoxContainer/CardsInDeckScroller/CardsInDeck.add_child(hbox_container)
	hbox_container.add_child(n_label)
	hbox_container.add_child(card)
	cards_in_deck[card_index] = {
		"NCards": 1,
		"Card": card,
		"Label": n_label,
	}


func remove_from_deck(card_index: int) -> void:
	cards_in_deck[card_index]["NCards"] -= 1
	if cards_in_deck[card_index]["NCards"] == 0:
		cards_in_deck[card_index]["Card"].queue_free()
		cards_in_deck.erase(card_index)
	else:
		cards_in_deck[card_index]["Label"] = cards_in_deck[card_index]["NCards"]
	
	_add_to_collection_options(card_index)


func _add_to_collection_options(card_index: int) -> void:
	if card_index in card_collection_options.keys():
		card_collection_options[card_index]["NCards"] += 1
		card_collection_options[card_index]["Label"].text = str(card_collection_options[card_index][
			"NCards"
		])
	else:
		_add_new_card_to_collection_options(card_index)


func _add_new_card_to_collection_options(card_index: int) -> void:
	var hbox_container := HBoxContainer.new()
	var n_label := Label.new()
	var card := deck_builder_card_scene.instantiate()
	
	n_label.text = "1"
	card.card_index = card_index
	card.is_in_deck = false
	$HBoxContainer/FilteredCardsScroller/FilteredCards.add_child(hbox_container)
	hbox_container.size_flags_horizontal = 4
	hbox_container.add_child(n_label)
	hbox_container.add_child(card)
	card_collection_options[card_index] = {
		"NCards": 1,
		"Card": hbox_container,
		"Label": n_label,
	}


func remove_from_collection_options(card_index: int) -> void:
	card_collection_options[card_index]["NCards"] -= 1
	if card_collection_options[card_index]["NCards"] == 0:
		card_collection_options[card_index]["Card"].queue_free()
		card_collection_options.erase(card_index)
	else:
		card_collection_options[card_index]["Label"].text = str(
			card_collection_options[card_index]["NCards"]
		)


func _setup_cards_from_card_collection() -> void:
	for c in CardCollection.collection:
		for i in CardCollection.collection[c]:
			_add_to_collection_options(c)


func _set_zoom_preview_position_and_size() -> void:
	var zoom_preview_size: Vector2 = Vector2(
		size.x * 0.3, size.x * 0.3
	)
	# Multiplying the zoom_preview_size.x with 1.1 to adjust for border size
	zoom_preview.position.x = MapSettings.total_screen.x - zoom_preview_size.x * 1.05 
	zoom_preview.position.y = MapSettings.play_area_start.y
	zoom_preview.custom_minimum_size.x = zoom_preview_size.x
	zoom_preview.custom_minimum_size.y = zoom_preview_size.y
