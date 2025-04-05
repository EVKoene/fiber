extends CardInPlay

class_name HeartOfTheForest


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if (
		(trigger == Collections.triggers.CARD_CREATED or trigger == Collections.triggers.CARD_MOVED)
		and triggering_card == self
	):
		for ps in spaces_in_range(2, true):
			if ps != current_play_space:
				ps.update_stat_modifier(card_owner_id, Collections.stats.HEALTH, 2)
		for ps in spaces_in_range(1, true):
			if ps != current_play_space:
				ps.update_stat_modifier(card_owner_id, Collections.stats.HEALTH, 2)
	elif (
		(
			trigger == Collections.triggers.CARD_DESTROYED
			or trigger == Collections.triggers.CARD_MOVING_AWAY
		)
		and triggering_card == self
	):
		for ps in spaces_in_range(2, true):
			if ps != current_play_space:
				ps.update_stat_modifier(card_owner_id, Collections.stats.HEALTH, -2)
		for ps in spaces_in_range(1, true):
			if ps != current_play_space:
				ps.update_stat_modifier(card_owner_id, Collections.stats.HEALTH, -2)
	
	return
