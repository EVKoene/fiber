extends CardInPlay

class_name FelosExpeditionist


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if trigger == Collections.triggers.ATTACK_FINISHED and triggering_card == self:
		if GameManager.is_single_player:
			BattleSynchronizer.draw_card(card_owner_id)
		if !GameManager.is_single_player:
			BattleSynchronizer.draw_card.rpc_id(1, card_owner_id)
