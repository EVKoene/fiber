extends Node

class_name AIPlayer


var ai_turn_manager: AITurnManager
var player_id: int


func discard_card() -> void:
	var card: CardInHand
	card = GameManager.cards_in_hand[player_id].picK_random
	card.discard()
