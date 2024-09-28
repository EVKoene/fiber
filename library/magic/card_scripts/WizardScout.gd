extends CardInPlay


class_name WizardScout


func _init():
	abilities = [
		{
			"FuncName": "swap",
			"FuncText": "Swap",
			"AbilityCosts": Costs.new(0, 0, 0, 0),
		},
	]


func swap() -> bool:
	select_card(true)
	Events.show_instructions.emit("Choose a card to swap with")
	GameManager.battle_map.show_finish_button()
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, self, false, -1, true
	)
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
		swap_with_card(
			TargetSelection.selected_targets[0].card_owner_id,
			TargetSelection.selected_targets[0].card_in_play_index
		)
		exhaust()
		TargetSelection.making_selection = false
		TargetSelection.end_selecting()
		return true
	else:
		TargetSelection.end_selecting()
		return false


func resolve_ability_for_ai() -> void:
	var card_to_swap_with: CardInPlay
	card_to_swap_with = AIHelper.cards_to_swap_with(self).pick_random()
	select_card(true)
	await get_tree().create_timer(0.5).timeout
	swap_with_card(card_to_swap_with.card_owner_id, card_to_swap_with.card_in_play_index)
	exhaust()
	TargetSelection.end_selecting()


func is_ability_to_use_now() -> bool:
	if len(AIHelper.cards_to_swap_with(self)) > 0:
		return true

	return false
