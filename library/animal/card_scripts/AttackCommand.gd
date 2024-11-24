extends CardInPlay


class_name AttackCommand

func resolve_spell(c_column: int, c_row: int) -> bool:
	var selected_card: CardInPlay = (
		GameManager.ps_column_row[c_column][c_row].card_in_this_play_space
	)
	Events.show_instructions.emit("Choose a unit to attack")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.ANY_UNITS, selected_card, 
		false, 2, true
	)
	selected_card.select_card(true)
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
	
		var card_to_attack: CardInPlay = TargetSelection.selected_targets[0]
		selected_card.attack_card(card_to_attack)
		
		BattleSynchronizer.finish_resolve()
		return true
	
	else:
		BattleSynchronizer.finish_resolve()
		return false
