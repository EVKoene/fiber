extends Node


@rpc("any_peer", "call_local")
func set_progress_bars() -> void:
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		var occupied_resource_spaces := 0
		for s in GameManager.resource_spaces:
			if !s.card_in_this_play_space:
				continue
			if s.card_in_this_play_space.card_owner_id == p_id:
				occupied_resource_spaces += 1
		
		if (
			occupied_resource_spaces > MapSettings.n_progress_bars 
			and GameManager.player_id == p_id
		):
			GameManager.battle_map.show_text("You win!")
			get_tree().quit()
		elif (
			occupied_resource_spaces > MapSettings.n_progress_bars 
			and GameManager.player_id != p_id
		):
			GameManager.battle_map.show_text("You lose!")
			get_tree().quit()
		
		for b in range(len(GameManager.progress_bars[p_id])):
			if occupied_resource_spaces > b:
				GameManager.progress_bars[p_id][b].value = 100
			else:
				GameManager.progress_bars[p_id][b].value = 0


@rpc("call_local")
func remove_from_cards_in_play(card_owner_id: int, card_in_play_index: int) -> void:
	GameManager.cards_in_play[card_owner_id].remove_at(card_in_play_index)


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


@rpc("any_peer", "call_local")
func animate_attack(card_owner_id: int, card_in_play_index: int, direction: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][card_in_play_index]
	match direction:
		Collections.directions.UP:
			card.position.y -= MapSettings.play_space_size.y / 2
			await get_tree().create_timer(0.25).timeout
			card.position.y += MapSettings.play_space_size.y / 2
		Collections.directions.DOWN:
			card.position.y += MapSettings.play_space_size.y / 2
			await get_tree().create_timer(0.25).timeout
			card.position.y -= MapSettings.play_space_size.y / 2
		Collections.directions.RIGHT:
			card.position.x += MapSettings.play_space_size.x / 2
			await get_tree().create_timer(0.25).timeout
			card.position.x -= MapSettings.play_space_size.x / 2
		Collections.directions.LEFT:
			card.position.x -= MapSettings.play_space_size.x / 2
			await get_tree().create_timer(0.25).timeout
			card.position.x += MapSettings.play_space_size.x / 2


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
