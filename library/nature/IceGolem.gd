extends CardInPlay


class_name IceGolem


func deal_damage_to_card(card: CardInPlay, value: int) -> void:
	for p_id in GameManager.players:
		CardManipulation.change_max_attack.rpc_id(
			p_id, card.card_owner_id, card.card_in_play_index, -1, 2
		)
		CardManipulation.change_movement.rpc_id(
			p_id, card.card_owner_id, card.card_in_play_index, -1, 2
		)
	card.resolve_damage(value)
