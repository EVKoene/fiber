extends CardInPlay


class_name ArcaneArrow


func resolve_spell(selected_column: int, selected_row: int) -> bool:
	var selected_card: CardInPlay = (
		GameManager.ps_column_row[selected_column][selected_row].card_in_this_play_space
	)
	selected_card.highlight_card(true)
	await attack_card
	selected_card.resolve_damage(3)
	return true
