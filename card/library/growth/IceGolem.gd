extends CardInPlay

class_name IceGolem


func deal_damage_to_card(card: CardInPlay, value: int) -> void:
	CardManipulation.change_battle_stat(
		Collections.stats.MAX_ATTACK, card.card_owner_id, card.card_in_play_index, -1, 2
	)
	CardManipulation.change_battle_stat(
		Collections.stats.MOVEMENT, card.card_owner_id, card.card_in_play_index, -1, 2
	)

	card.resolve_damage(value)
