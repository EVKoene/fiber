extends CardInPlay

class_name BringerOfEnlightenment


func call_triggered_funcs(trigger: int, _triggering_card: Card) -> void:
	if (
		trigger != Collections.triggers.TURN_STARTED
		or GameManager.turn_manager.turn_owner_id != card_owner_id
	):
		return

	for ps in spaces_in_range(2, true):
		if (
			!ps.card_in_this_play_space
			or ps.card_in_this_play_space == self
			or ps.card_in_this_play_space.card_owner_id != card_owner_id
		):
			continue

		if ps.card_in_this_play_space.health >= 5:
			var card: CardInPlay = ps.card_in_this_play_space
			CardManipulation.change_battle_stat(
				Collections.stats.MAX_ATTACK, card.card_owner_id, card.card_in_play_index, 3, 1
			)
