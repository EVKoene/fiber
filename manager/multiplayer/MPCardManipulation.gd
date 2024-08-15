extends Node


@rpc("any_peer", "call_local")
func destroy(card_owner_id: int, cip_index: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.current_play_space.card_in_this_play_space = null
	GameManager.call_triggered_funcs(Collections.triggers.CARD_DESTROYED, card)
	card.remove_from_cards_in_play()
	card.queue_free()



@rpc("any_peer", "call_local")
func update_stats(card_owner_id: int, cip_index: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.update_stats()


@rpc("any_peer", "call_local")
func change_max_attack(card_owner_id: int, cip_index: int, value: int, duration: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.battle_stats.change_max_attack(value, duration)


@rpc("any_peer", "call_local")
func change_min_attack(card_owner_id: int, cip_index: int, value: int, duration: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.battle_stats.change_min_attack(value, duration)


@rpc("any_peer", "call_local")
func change_health(card_owner_id: int, cip_index: int, value: int, duration: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.battle_stats.change_health(value, duration)


@rpc("any_peer", "call_local")
func change_movement(card_owner_id: int, cip_index: int, value: int, duration: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.battle_stats.change_movement(value, duration)


@rpc("any_peer", "call_local")
func highlight_card(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.get_theme_stylebox("panel").border_color = Styling.gold_color


@rpc("any_peer", "call_local")
func set_all_borders_to_faction() -> void:
	for p_id in GameManager.players:
		for c in GameManager.cards_in_play[p_id]:
			c.set_border_to_faction()


@rpc("any_peer", "call_local")
func set_border_to_faction(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.set_border_to_faction()
