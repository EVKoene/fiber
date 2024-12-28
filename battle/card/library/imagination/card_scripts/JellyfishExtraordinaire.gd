extends CardInPlay


class_name JellyfishExtraordinaire


func call_triggered_funcs(trigger: int, _triggering_card: CardInPlay):
	if (
		trigger == Collections.triggers.TURN_STARTED
		and Collections.play_space_attributes.VICTORY_SPACE in current_play_space.attributes
		and !current_play_space.is_in_starting_area(card_owner_id)
	):
		if GameManager.is_single_player:
			BattleSynchronizer.draw_card(card_owner_id)
		if !GameManager.is_single_player:
			BattleSynchronizer.draw_card.rpc_id(1, card_owner_id)
		
		GameManager.resources[card_owner_id].add_resource(Collections.fibers.IMAGINATION, 1)
