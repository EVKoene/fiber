extends CardInPlay


class_name AttackCommand

func resolve_spell(c_column: int, c_row: int) -> bool:
	var selected_card: CardInPlay = (
		GameManager.ps_column_row[c_column][c_row].card_in_this_play_space
	)
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.ANY_UNITS, selected_card, 
		false, 2, true
	)
	selected_card.select_card(true)
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
		MPManager.ask_resolve_spell_agreement()
		await Events.resolve_spell_button_pressed
	
		var card_to_attack: CardInPlay = TargetSelection.selected_targets[0]
		selected_card.attack_card(card_to_attack)
		GameManager.resources[card_owner_id].add_resource(Collections.factions.ANIMAL, 1)
		for p_id in GameManager.players:
			TargetSelection.end_selecting.rpc_id(p_id)
		return true
	else:
		return false
