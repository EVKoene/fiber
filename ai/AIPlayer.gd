extends Node

class_name AIPlayer


var ai_turn_manager: AITurnManager
var player_id: int


func play_turn() -> void:
	ai_turn_manager.end_turn()


func discard_card() -> void:
	var card: CardInHand
	card = GameManager.cards_in_hand[player_id].picK_random
	card.discard()
