extends CardInPlay

class_name OverstimulationFiend


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if (
		(trigger == Collections.triggers.CARD_CREATED or trigger == Collections.triggers.CARD_MOVED)
		and triggering_card == self
	):
		for ps in current_play_space.adjacent_play_spaces():
			ps.update_stat_modifier(
				GameManager.opposing_player_id(card_owner_id), Collections.stats.MOVEMENT, -1
			)
	elif (
		(
			trigger == Collections.triggers.CARD_DESTROYED
			or trigger == Collections.triggers.CARD_MOVING_AWAY
		)
		and triggering_card == self
	):
		for ps in current_play_space.adjacent_play_spaces():
			ps.update_stat_modifier(
				GameManager.opposing_player_id(card_owner_id), Collections.stats.MOVEMENT, 1
			)
