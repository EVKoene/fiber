extends CardInPlay

class_name ImaginaryFriend


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if (
		trigger == Collections.triggers.SPELL_PLAYED
		and triggering_card.card_owner_id == card_owner_id
	):
		var stat_to_increase: int = (
			[Collections.stats.MAX_ATTACK, Collections.stats.MIN_ATTACK, Collections.stats.HEALTH]
			. pick_random()
		)

		CardManipulation.change_battle_stat(
			stat_to_increase, card_owner_id, card_in_play_index, 1, -1
		)
