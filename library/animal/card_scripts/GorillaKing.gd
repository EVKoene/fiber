extends CardInPlay


class_name GorillaKing

var n_adj_units := {}


func call_triggered_funcs(trigger: int, triggering_card: CardInPlay) -> void:
	if !(
		trigger == Collections.triggers.CARD_CREATED 
		or trigger == Collections.triggers.CARD_MOVED
		or trigger == Collections.triggers.CARD_DESTROYED
	):
		return
	
	if trigger == Collections.triggers.CARD_DESTROYED and triggering_card == self:
		for c in n_adj_units:
			CardManipulation.change_max_attack(
				c.card_owner_id, c.card_in_play_index, -n_adj_units[c] * 2, -1
			)
		return

	for c in n_adj_units:
		if !is_instance_valid(c):
			n_adj_units.erase(c)
	
	for c in GameManager.cards_in_play[card_owner_id]:
		if !n_adj_units.has(c):
			n_adj_units[c] = 0
	
	for c in n_adj_units.keys():
		var count := len(
			CardHelper.cards_in_range_of_card(
				c, 1, TargetSelection.target_restrictions.OWN_UNITS
			)
		)
		var increase_in_n_adj_units: int
		increase_in_n_adj_units =  count - n_adj_units[c]
		CardManipulation.change_max_attack(
			c.card_owner_id, c.card_in_play_index, increase_in_n_adj_units * 2, -1
		)
		n_adj_units[c] = count
