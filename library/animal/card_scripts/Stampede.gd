extends CardInPlay

class_name Stampede


func resolve_spell(_c_column: int, _c_row: int) -> bool:
	for c in GameManager.cards_in_play[card_owner_id]:
		if GameManager.is_single_player:
			CardManipulation.change_max_attack(card_owner_id, card_in_play_index, 2, 2)
			c.battle_stats.change_min_attack(card_owner_id, card_in_play_index, 2, 2)
			c.battle_stats.change_health(card_owner_id, card_in_play_index, 2, 2)
			c.battle_stats.change_movement(card_owner_id, card_in_play_index, 1, 2)
			c.update_stats(card_owner_id, card_in_play_index)
		if !GameManager.is_single_player:
			for p_id in GameManager.players:
				CardManipulation.change_max_attack.rpc_id(
					p_id, card_owner_id, card_in_play_index, 2, 2
				)
				c.battle_stats.change_min_attack.rpc_id(
					p_id, card_owner_id, card_in_play_index, 2, 2
				)
				c.battle_stats.change_health.rpc_id(
					p_id, card_owner_id, card_in_play_index, 2, 2
				)
				c.battle_stats.change_movement.rpc_id(
					p_id, card_owner_id, card_in_play_index, 1, 2
				)
				c.update_stats.rpc_id(p_id, card_owner_id, card_in_play_index)

	return true


func resolve_spell_for_ai() -> void:
	resolve_spell(-1, -1)
