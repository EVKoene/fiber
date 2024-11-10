extends Node


class_name BuildDeck

var cards := {}

func add_card(card: DeckBuilderCard) -> void:
	if card.card_index in cards.values:
		cards[card.card_index] += 1
	else:
		cards[card.card_index] = 1


func remove_card(card: DeckBuilderCard) -> void:
	assert(
		card.card_index in cards.values, str(
			"Tried to remove card that is not currently in deck: ", card.card_name)
	)
	if cards[card.card_index] == 1:
		cards.erase(card.card_index)
	else:
		cards[card.card_index] -= 1
