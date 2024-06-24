extends Node


class_name Player

@onready var card_scene: PackedScene = preload("res://card/CardInPlay.tscn")

var player_id: int
var deck: Deck
var resources: Resources
var deck_data: Dictionary
var cards_in_play := []


func _init(_player_id: int, _deck_data: Dictionary):
	player_id = _player_id
	deck_data = _deck_data


func _ready():
	create_resources()
	_load_deck()


func _load_deck() -> void:
	deck = Deck.new(self, deck_data["Cards"], deck_data["StartingCards"])
	add_child(deck)


func create_resources() -> void:
	resources = Resources.new(player_id)
	add_child(resources)
	GameManager.resources[player_id] = resources
