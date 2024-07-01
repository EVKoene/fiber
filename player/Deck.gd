extends Node

class_name Deck


var deck_owner_id: int
var deck_order: Array
var cards: Dictionary
var starting_cards: Dictionary
var cards_spawned: int = 0


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
	
	for c in GameManager.starting_draw:
		draw_card()


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
	create_hand_card(deck_order[0])
	deck_order.remove_at(0)


func draw_type_put_rest_bottom(card_type: int) -> bool:
	var card_drawn: bool = false
	var card_index: int = -1
	var deck_index: int = -1
	for c in deck_order:
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
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		MultiPlayerManager.create_hand_card.rpc_id(p_id, deck_owner_id, card_index)

func put_card_bottom(deck_index) -> void:
	var card_index = deck_order[deck_index]
	deck_order.remove_at(deck_index)
	deck_order.append(card_index)
