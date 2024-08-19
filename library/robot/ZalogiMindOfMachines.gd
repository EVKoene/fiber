extends CardInPlay


class_name ZalogiMindOfMachines


func call_triggered_funcs(trigger: int, triggering_card: CardInPlay) -> void:
	if trigger != Collections.triggers.CARD_CREATED or !triggering_card:
		return
	if triggering_card.fabrication and triggering_card.card_owner_id == card_owner_id:
		for p_id in GameManager.players:
			MPCardManipulation.change_max_attack.rpc_id(
				p_id, card_owner_id, triggering_card.card_in_play_index, 2, -1
			)
			MPCardManipulation.change_min_attack.rpc_id(
				p_id, card_owner_id, triggering_card.card_in_play_index, 2, -1
			)
			MPCardManipulation.change_health.rpc_id(
				p_id, card_owner_id, triggering_card.card_in_play_index, 2, -1
			)
			MPCardManipulation.change_movement.rpc_id(
				p_id, card_owner_id, triggering_card.card_in_play_index, 1, -1
			)
