extends Node

class_name Deck


var deck_owner_id: int
var deck_order: Array
var cards: Dictionary
var starting_cards: Dictionary
var cards_spawned := 0
var discard := []
var n_cards_to_pick_from := 3


func _init(_deck_owner_id: int, _cards: Dictionary, _starting_cards: Dictionary):
	deck_owner_id = _deck_owner_id
	cards = _cards
	starting_cards = _starting_cards


func _ready():
	assert(
		GameManager.is_server, str("Decks should only be created by server. Was instead created
		by player with player_id ", GameManager.player_id)
	)
	draw_starting_cards()
	shuffle()


func shuffle() -> void:
	var all_cards_array: Array = []
	if len(deck_order) > 0:
		all_cards_array = deck_order.duplicate()
		deck_order.clear()
	
	else:
		for card in cards:
			for card_copy in range(cards[card]):
				all_cards_array.append(card)
	
	for card_from_top in len(all_cards_array):
		var random_card: int = all_cards_array.pick_random()
		deck_order.append(random_card)
		all_cards_array.erase(random_card)


func draw_card() -> void:
	GameManager.turn_manager.set_turn_actions_enabled(false)
	create_hand_card(deck_order[0])
	deck_order.remove_at(0)
	GameManager.turn_manager.set_turn_actions_enabled(true)


func pick_card_option() -> void:
	GameManager.turn_manager.set_turn_actions_enabled(false)
	if GameManager.is_single_player:
		GameManager.battle_map.pick_card_option(deck_order.slice(0, n_cards_to_pick_from))
	if !GameManager.is_single_player:
		GameManager.battle_map.pick_card_option.rpc_id(deck_owner_id, deck_order.slice(0, n_cards_to_pick_from))
	for c in range(n_cards_to_pick_from):
		# We return the cards to the back of the deck
		deck_order.append(c)
		deck_order.remove_at(c)


func draw_type_put_rest_bottom(card_type: int) -> bool:
	var card_drawn: bool = false
	var card_index: int = -1
	var deck_index: int = -1
	for c in len(deck_order):
		var card_info = CardDatabase.cards_info[deck_order[c]]
		if card_info["CardType"] == card_type:
			card_index = deck_order[c]
			deck_index = c
			break

	if card_index != -1:
		create_hand_card(card_index)
		
		# Put all cards with another type before the card we drew on the bottom
		for i in range(deck_index - 1):
			put_card_bottom(0)
		
		deck_order.remove_at(0)
		card_drawn = true
	
	return card_drawn


func draw_starting_cards() -> void:
	for c in starting_cards:
		for copy in starting_cards[c]:
			create_hand_card(c)


func create_hand_card(card_index: int) -> void:
	if len(GameManager.cards_in_hand[deck_owner_id]) >= 7:
		if GameManager.is_single_player:
			TargetSelection.select_card_to_discard()
		if !GameManager.is_single_player:
			TargetSelection.select_card_to_discard.rpc_id(deck_owner_id)
	
	if GameManager.is_single_player:
		BattleSynchronizer.create_hand_card(deck_owner_id, card_index)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleSynchronizer.create_hand_card.rpc_id(p_id, deck_owner_id, card_index)


func put_card_bottom(deck_index) -> void:
	var card_index = deck_order[deck_index]
	deck_order.remove_at(deck_index)
	deck_order.append(card_index)


func send_to_discard(card_index: int) -> void:
	discard.append(card_index)
