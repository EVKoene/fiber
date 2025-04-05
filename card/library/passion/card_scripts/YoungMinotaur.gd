extends CardInPlay

class_name YoungDrivenMinotaur


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if (
		trigger == Collections.triggers.ATTACK
		and triggering_card.card_owner_id == card_owner_id
		and triggering_card.current_play_space in spaces_in_range(2, true)
	):
		CardManipulation.change_battle_stat(
			Collections.stats.MAX_ATTACK, card_owner_id, card_in_play_index, 1, -1
		)
		CardManipulation.change_battle_stat(
			Collections.stats.HEALTH, card_owner_id, card_in_play_index, 1, -1
		)
	
	return
