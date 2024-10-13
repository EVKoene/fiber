extends Node


@rpc("any_peer", "call_local")
func change_battle_stat(
	battle_stat: int, card_owner_id: int, cip_index: int, value: int, duration: int
) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.battle_stats.change_battle_stat(battle_stat, value, duration)
