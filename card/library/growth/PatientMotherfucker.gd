extends CardInPlay

class_name PatientMotherfucker


var has_moved

func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if trigger == Collections.triggers.TURN_STARTED:
		if !has_moved:
			CardManipulation.change_battle_stat(
				Collections.stats.MAX_ATTACK, card_owner_id, card_in_play_index, 2, 2
			)
			CardManipulation.change_battle_stat(
				Collections.stats.MIN_ATTACK, card_owner_id, card_in_play_index, 2, 2
			)
			CardManipulation.change_battle_stat(
				Collections.stats.SHIELD, card_owner_id, card_in_play_index, 2, 2
			)
