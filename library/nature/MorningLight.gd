extends CardInPlay


class_name MorningLight


func resolve_spell(selected_column: int, selected_row: int) -> bool:
	var selected_card: CardInPlay = (
		GameManager.ps_column_row[selected_column][selected_row].card_in_this_play_space
	)
	selected_card.highlight_card(true)
	for p_id in GameManager.players:
		CardManipulation.change_health.rpc_id(
			p_id, card_owner_id, card_in_play_index, 2, -1
		)
		CardManipulation.change_movement.rpc_id(
			p_id, card_owner_id, card_in_play_index, 1, -1
		)
	return true
