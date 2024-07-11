extends Node

"""
In this script you will find functions to synchronize the battlefield between players. If a player
creates or moves a card, the specified functions should be called here by both players with the
necessary information. This means we hardly use the multiplayer spawner or synchronizer, as both
client and server will create objects and execute functionality seperately. 
"""

@onready var card_in_play_scene: PackedScene = preload("res://card/CardInPlay.tscn")
@onready var card_in_hand_scene: PackedScene = preload("res://card/CardInHand.tscn")


@rpc("any_peer", "call_local")
func refresh_unit(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.modulate = Color(1, 1, 1, 1)
	card.exhausted = false


@rpc("any_peer", "call_local")
func exhaust_unit(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.modulate = Color(0.5, 0.5, 0.5, 1)
	card.exhausted = true


@rpc("any_peer", "call_local")
func resolve_damage(card_owner_id, cip_index, value):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	if value > 0:
		card.shake()
	
	card.battle_stats.change_health(-value, -1)
	card.update_stats()
	if card.health <= 0:
		card.destroy()


@rpc("any_peer", "call_local")
func play_spell(
	card_index: int, hand_index: int, card_owner_id: int, column: int, row: int
) -> void:
	var hand_card: CardInHand = GameManager.cards_in_hand[card_owner_id][hand_index]
	var h_index = hand_card.hand_index
	GameManager.zoom_preview.lock_zoom_preview_hand(hand_card)
	var card: CardInPlay = CardDatabase.get_card_class(hand_card.card_index).new()
	card.card_owner_id = hand_card.card_owner_id
	
	var succesfull_resolve: bool = await card.resolve_spell(column, row)
	if succesfull_resolve:
		GameManager.resources[card_owner_id].pay_costs(hand_card.costs)
		MultiPlayerManager.remove_card_from_hand(card_owner_id, h_index)
	
	GameManager.zoom_preview.reset_zoom_preview()

	TargetSelection.end_selecting()




@rpc("any_peer", "call_local")
func play_unit(card_index: int, card_owner_id: int, column: int, row: int) -> void:
	var card: CardInPlay = card_in_play_scene.instantiate()
	card.set_script(CardDatabase.get_card_class(card_index))
	card.card_owner_id = card_owner_id
	card.card_index = card_index
	card.column = column
	card.row = row
	GameManager.cards_in_play[card_owner_id].append(card)
	GameManager.battle_map.add_child(card)
	GameManager.zoom_preview.reset_zoom_preview()
	set_progress_bars()


@rpc("any_peer", "call_local")
func remove_card_from_hand(card_owner_id: int, hand_index: int) -> void:
	var card: CardInHand = GameManager.cards_in_hand[card_owner_id][hand_index]
	GameManager.cards_in_hand[card_owner_id].remove_at(hand_index)
	set_hand_card_positions()
	card.queue_free()

@rpc("any_peer", "call_local")
func highlight_card(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	var border_style = load("res://styling/card_borders/CardSelectedBorder.tres")
	card.add_theme_stylebox_override("panel", border_style)


@rpc("any_peer", "call_local")
func create_hand_card(card_owner_id: int, card_index: int) -> void:
	var hand_card: CardInHand = card_in_hand_scene.instantiate()
	hand_card.card_index = card_index
	hand_card.card_owner_id = card_owner_id
	GameManager.battle_map.add_child(hand_card)


@rpc("any_peer", "call_local")
func set_resources(
	resource_owner_id: int, gold: int, animal: int, magic: int, nature: int, robot: int
) -> void:
	GameManager.resource_bars[resource_owner_id].set_resources_labels(
		gold, animal, magic, nature, robot
	)


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


@rpc("any_peer", "call_local")
func remove_from_cards_in_play(card: CardInPlay) -> void:
	var card_owner_id := card.card_owner_id
	var card_in_play_index := card.card_in_play_index
	for p_id in GameManager.players:
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


@rpc("any_peer", "call_local")
func set_hand_card_positions() -> void:
	for p in GameManager.cards_in_hand:
		for k in range(len(GameManager.cards_in_hand[p])):
			var card: CardInHand = GameManager.cards_in_hand[p][k]
			card.set_card_position()


@rpc("any_peer", "call_local")
func set_border_to_faction(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.set_border_to_faction()
