extends CardInPlay


class_name GorillaKing

var ps_adj_units := {} 


func call_triggered_funcs(trigger: int, triggering_card: CardInPlay) -> void:
	if !(
		trigger == Collections.triggers.CARD_CREATED 
		or trigger == Collections.triggers.CARD_MOVED
		or trigger == Collections.triggers.CARD_DESTROYED
	):
		return
	
	if triggering_card == self:
		for ps in GameManager.play_spaces:
			ps_adj_units[ps] = 0
	
	for ps in ps_adj_units:
		if !ps.card_in_this_play_space:
			continue
		var adj_own_units := len(
			CardHelper.cards_in_range_of_card(
				ps.card_in_this_play_space, 1, TargetSelection.target_restrictions.OWN_UNITS
			)
		)
		var increase_in_adj_units: int
		increase_in_adj_units =  adj_own_units - ps_adj_units[ps]
		ps.update_stat_modifier(card_owner_id, Collections.stats.MAX_ATTACK, increase_in_adj_units * 2)
		ps_adj_units[ps] = adj_own_units
