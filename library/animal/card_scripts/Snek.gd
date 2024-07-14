extends CardInPlay

class_name Snek


func call_triggered_funcs(trigger: int, triggering_card: CardInPlay) -> void:
	if trigger not in [Collections.triggers.CARD_MOVED, Collections.triggers.CARD_CREATED]:
		return

	if (triggering_card.card_owner_id != card_owner_id 
		and triggering_card.current_play_space in current_play_space.adjacent_play_spaces()
		and is_instance_valid(triggering_card)
	): 
		triggering_card.resolve_damage(1)
