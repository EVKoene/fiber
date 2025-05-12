extends CardInPlay

class_name AudaciousResearcher


func call_triggered_funcs(trigger: int, _triggering_card: Card) -> void:
	if (
		trigger == Collections.triggers.TURN_STARTED
		and GameManager.turn_manager.turn_owner_id == card_owner_id
	):
		GameManager.decks[card_owner_id].draw_type_put_rest_bottom(Collections.card_types.SPELL)
	return
	
