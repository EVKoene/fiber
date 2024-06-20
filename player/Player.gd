extends Node


class_name Player


var player_id: int
var deck: Deck
var deck_data: Dictionary
var cards_in_hand := []


func _init(_player_id: int, _deck_data: Dictionary):
	player_id = _player_id
	deck_data = _deck_data


func _ready():
	_load_deck()


func _load_deck() -> void:
	deck = Deck.new(self, deck_data["Cards"], deck_data["StartingCards"])
	add_child(deck)
