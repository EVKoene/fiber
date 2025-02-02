extends CardInPlay

class_name PatientDude

var has_moved := false


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if (
		trigger == Collections.triggers.TURN_STARTED
		and GameManager.turn_manager.turn_owner_id == card_owner_id
	):
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

		has_moved = false

	if trigger == Collections.triggers.CARD_MOVED and triggering_card == self:
		has_moved = true
