extends CardInPlay

class_name ZalogiMindOfMachines


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if trigger != Collections.triggers.CARD_CREATED or !triggering_card:
		return
	if triggering_card.fabrication and triggering_card.card_owner_id == card_owner_id:
		for stat in [
			Collections.stats.MAX_ATTACK, Collections.stats.MIN_ATTACK, Collections.stats.HEALTH
		]:
			CardManipulation.change_battle_stat(
				stat, card_owner_id, triggering_card.card_in_play_index, 2, -1
			)
		CardManipulation.change_battle_stat(
			Collections.stats.MOVEMENT, card_owner_id, triggering_card.card_in_play_index, 1, -1
		)
