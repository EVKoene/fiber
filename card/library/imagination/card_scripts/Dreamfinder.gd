extends CardInPlay

class_name Dreamfinder


func enter_battle() -> void:
	for c in GameManager.cards_in_hand[card_owner_id]:
		if c.costs.imagination >= 1:
			c.costs.imagination -= 1


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if trigger == Collections.triggers.CARD_CREATED and triggering_card == self:
		for c in GameManager.cards_in_hand[card_owner_id]:
			if c.costs.imagination >= 1 and c.card_type == Collections.card_types.SPELL:
				c.costs.change_cost(Collections.fibers.IMAGINATION, -1)

	elif (
		trigger == Collections.triggers.CARD_ADDED_TO_HAND
		and triggering_card.card_owner_id == card_owner_id
		and triggering_card.card_type == Collections.card_types.SPELL
	):
		var triggering_card_data: Dictionary = CardDatabase.cards_info[triggering_card.card_index]
		if (
			triggering_card_data["Costs"][Collections.fibers.IMAGINATION]
			and triggering_card.costs.imagination >= 1
		):
			triggering_card.costs.change_cost(Collections.fibers.IMAGINATION, -1)

	elif trigger == Collections.triggers.CARD_DESTROYED and triggering_card == self:
		for c in GameManager.cards_in_hand[card_owner_id]:
			var c_card_data: Dictionary = CardDatabase.cards_info[c.card_index]
			if (
				c_card_data["Costs"][Collections.fibers.IMAGINATION] >= 1
				and c.card_type == Collections.card_types.SPELL
			):
				triggering_card.costs.change_cost(Collections.fibers.IMAGINATION, 1)
