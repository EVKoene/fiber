extends CardInPlay

class_name ResourceExtractor


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if trigger == Collections.triggers.ATTACK_FINISHED and triggering_card == self:
		GameManager.resources[card_owner_id].add_resource(Collections.fibers.LOGIC, 2)
	
	return
