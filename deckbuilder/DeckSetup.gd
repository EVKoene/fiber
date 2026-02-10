extends Node


@onready var deck: Dictionary:
	get = _get_current_deck


func setup_starter_deck(fiber: int) -> void:
	var config := ConfigFile.new()
	config.load(GameManager.collections_path)
	var cards := {}
	
	if config.get_value("card_collection", "cards"):
		cards = config.get_value("card_collection", "cards")
	
	var starter_deck_id: int
	match fiber:
		Collections.fibers.PASSION:
			starter_deck_id = DeckCollection.deck_ids.PASSION_STARTER
		Collections.fibers.IMAGINATION:
			starter_deck_id = DeckCollection.deck_ids.IMAGINATION_STARTER
		Collections.fibers.GROWTH:
			starter_deck_id = DeckCollection.deck_ids.GROWTH_STARTER
		Collections.fibers.LOGIC:
			starter_deck_id = DeckCollection.deck_ids.LOGIC_STARTER

	for c in DeckCollection.decks[starter_deck_id]["Cards"].keys():
		cards[c] = DeckCollection.decks[starter_deck_id]["Cards"][c]
	
	var existing_decks := {}
	if config.get_value("deck_data", "decks"):
		existing_decks = config.get_value("deck_data", "decks")
	existing_decks[starter_deck_id] = DeckCollection.decks[starter_deck_id]
		
	config.set_value("card_collection", "cards", cards)
	config.set_value("deck_data", "decks", existing_decks)
	config.set_value("deck_data", "current_deck_id", starter_deck_id)
	config.set_value("start_journey", "starting_fiber", fiber)
	var save_error := config.save(GameManager.collections_path)
	if save_error:
		print("Error creating card collection: ", error_string(save_error))


func set_current_multiplayer_deck(deck_id: int) -> void:
	var config := ConfigFile.new()
	config.load(GameManager.collections_path)
	var deck_collection: Dictionary = config.get_value("deck_data", "decks")
	GameManager.multiplayer_deck = deck_collection[deck_id]


func set_current_deck(deck_id: int) -> void:
	var config := ConfigFile.new()
	config.load(GameManager.collections_path)
	config.set_value("deck_data", "current_deck_id", deck_id)
	var save_error := config.save(GameManager.collections_path)
	if save_error:
		print("Error setting deck: ", error_string(save_error))


func remove_all_cards() -> void:
	var config := ConfigFile.new()
	config.load(GameManager.collections_path)
	config.set_value("card_collection", "cards", {})
	config.set_value("deck_data", "decks", {})
	var save_error := config.save(GameManager.collections_path)
	if save_error:
		print("Error removing cards: ", error_string(save_error))


func _get_current_deck() -> Dictionary:
	if GameManager.testing:
		return DeckCollection.decks[DeckCollection.deck_ids.PLAYER_TESTING]
	if GameManager.multiplayer_deck != {}:
		return GameManager.multiplayer_deck
	if !FileAccess.file_exists(GameManager.collections_path):
		return DeckCollection.decks[DeckCollection.pick_random_starter_deck()]
	
	var config := ConfigFile.new()
	config.load(GameManager.collections_path)
	var deck_collection: Dictionary = config.get_value("deck_data", "decks")
	var current_deck_id: int = config.get_value("deck_data", "current_deck_id")
	var current_deck: Dictionary = deck_collection[current_deck_id]
	return current_deck


func change_deck_to_passion() -> void:
	remove_all_cards()
	setup_starter_deck(Collections.fibers.PASSION)


func change_deck_to_imagination() -> void:
	remove_all_cards()
	setup_starter_deck(Collections.fibers.IMAGINATION)


func change_deck_to_growth() -> void:
	remove_all_cards()
	setup_starter_deck(Collections.fibers.GROWTH)


func change_deck_to_logic() -> void:
	remove_all_cards()
	setup_starter_deck(Collections.fibers.LOGIC)


func unlock_all_cards() -> void:
	for c in range(len(CardDatabase.cards)):
		PlayerManager.add_card_to_collection(c)
