extends Node

@rpc("any_peer", "call_local")
func destroy(card_owner_id: int, cip_index: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.current_play_space.card_in_this_play_space = null
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_DESTROYED, card)
	card.call_deferred("remove_from_cards_in_play")
	card.call_deferred("queue_free")


@rpc("any_peer", "call_local")
func update_stats(card_owner_id: int, cip_index: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.update_stats()


@rpc("any_peer", "call_local")
func change_battle_stat(
	battle_stat: int, card_owner_id: int, cip_index: int, value: int, duration: int
) -> void:
	if GameManager.is_single_player:
		var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
		card.battle_stats.change_battle_stat(battle_stat, value, duration)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			MPCardManipulation.change_battle_stat.rpc_id(
				p_id, battle_stat, card_owner_id, cip_index, value, duration
			)


@rpc("any_peer", "call_local")
func highlight_card(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.border = StyleBoxFlat.new()
	card.add_theme_stylebox_override("panel", card.border)
	card.border.bg_color = Color(99999900)
	card.border.border_color = Styling.gold_color
	card.get_theme_stylebox("panel").set_border_width_all(card.size.y / 11)
		


@rpc("any_peer", "call_local")
func hide_all_borders() -> void:
	for p_id in GameManager.players:
		for c in GameManager.cards_in_play[p_id]:
			c.hide_border()


@rpc("any_peer", "call_local")
func hide_border(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.hide_border()
