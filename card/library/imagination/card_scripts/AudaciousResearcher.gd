extends CardInPlay

class_name AudaciousResearcher


func call_triggered_funcs(trigger: int, _triggering_card: Card) -> void:
	if (
		trigger == Collections.triggers.TURN_STARTED
		and GameManager.turn_manager.turn_owner_id == card_owner_id
	):
		if (
			card_owner_id == GameManager.p1_id
			and current_play_space.row <= floor(float(MapSettings.n_rows) / 2.0)
		):
			GameManager.decks[card_owner_id].draw_type_put_rest_bottom(Collections.card_types.SPELL)
		elif (
			card_owner_id == GameManager.p2_id
			and current_play_space.row >= floor(float(MapSettings.n_rows) / 2.0)
		):
			GameManager.decks[card_owner_id].draw_type_put_rest_bottom(Collections.card_types.SPELL)
