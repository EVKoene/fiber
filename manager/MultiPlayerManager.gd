extends Node


@rpc("any_peer", "call_local")
func move_to_play_space(
	card_owner_id: int, card_in_play_index: int, new_column: int, new_row: int
) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][card_in_play_index]
	
	assert(
		!GameManager.ps_column_row[new_column][new_row].card_in_this_play_space, 
		"tried to move to occupied space"
	)
	
	card.current_play_space.card_in_this_play_space = null
	card.column = new_column
	card.row = new_row
	card.current_play_space.card_in_this_play_space = card
	card.set_position_to_play_space()


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
