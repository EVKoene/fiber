extends Node


@rpc("call_local")
func set_hand_card_positions() -> void:
	for p in GameManager.cards_in_hand:
		for k in range(len(GameManager.cards_in_hand[p])):
			var card: CardInHand = GameManager.cards_in_hand[p][k]
			card.set_card_position()


@rpc("call_local")
func set_resource_labels(
	player_id: int, 
	gold: int,
	animal: int,
	magic: int,
	nature: int,
	robot: int,
) -> void:
	match player_id:
		GameManager.p1_id:
			GameManager.resource_bar_p1.set_resources_labels(gold, animal, magic, nature, robot)
		GameManager.p2_id:
			GameManager.resource_bar_p2.set_resources_labels(gold, animal, magic, nature, robot)
