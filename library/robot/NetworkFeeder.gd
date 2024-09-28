extends CardInPlay


class_name NetworkFeeder


var n_allies_in_adjacent_spaces: int = 0


func call_triggered_funcs(trigger: int, _triggering_card: CardInPlay) -> void:
	if trigger in [
		Collections.triggers.CARD_CREATED, Collections.triggers.CARD_MOVED, Collections.triggers.CARD_MOVING_AWAY
	] and card_owner_id == _triggering_card.card_owner_id:
		var new_n_allies: int = len(
			CardHelper.cards_in_range_of_card(
				self, 1, TargetSelection.target_restrictions.OWN_UNITS
			)
		)

		var stat_increase: int = new_n_allies - n_allies_in_adjacent_spaces
		if GameManager.is_single_player:
			CardManipulation.change_max_attack(
				card_owner_id, card_in_play_index, stat_increase * 2, -1
			)
			CardManipulation.change_health(
				card_owner_id, card_in_play_index, stat_increase * 2, -1
			)
		
		if !GameManager.is_single_player:
			for p_id in GameManager.players:
				CardManipulation.change_max_attack.rpc_id(
					p_id, card_owner_id, card_in_play_index, stat_increase * 2, -1
				)
				CardManipulation.change_health.rpc_id(
					p_id, card_owner_id, card_in_play_index, stat_increase * 2, -1
				)
		
		n_allies_in_adjacent_spaces = new_n_allies
