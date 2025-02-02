extends CardInPlay

class_name Switcheroo


func resolve_spell() -> bool:
	Events.show_instructions.emit("Pick a unit")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.ANY_UNITS, null, false, -1, true
	)
	await TargetSelection.target_selection_finished
	var selected_card: CardInPlay
	if len(TargetSelection.selected_targets) == 1:
		selected_card = TargetSelection.selected_targets[0]
		TargetSelection.clear_selections()
	else:
		BattleSynchronizer.finish_resolve()
		return false
	selected_card.select_card(true)

	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, selected_card, false, -1, true
	)
	Events.show_instructions.emit("Choose another unit from the same owner")
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
		var target_card: CardInPlay = TargetSelection.selected_targets[0]
		selected_card.swap_with_card(target_card.card_owner_id, target_card.card_in_play_index)
		BattleSynchronizer.finish_resolve()
		return true
	else:
		BattleSynchronizer.finish_resolve()
		return false


func is_spell_to_play_now() -> bool:
	if len(GameManager.cards_in_play[card_owner_id]) == 0:
		return false

	for c in GameManager.cards_in_play[card_owner_id]:
		if len(AIHelper.cards_to_swap_with(c)) > 0:
			return true

	return false


func resolve_spell_for_ai() -> void:
	var cards_that_want_to_swap := []
	for c in GameManager.cards_in_play[card_owner_id]:
		if len(AIHelper.cards_to_swap_with(c)) > 0:
			cards_that_want_to_swap.append(c)

	assert(len(cards_that_want_to_swap) > 0, "AI unsuccessfully tried to swap cards")

	var card_to_swap: CardInPlay = (
		AIHelper
		. find_cards_with_stat_from_options(
			cards_that_want_to_swap,
			Collections.stats.TOTAL_COST,
			Collections.stat_params.HIGHEST,
			-1
		)
		. pick_random()
	)

	var card_to_swap_with: CardInPlay
	card_to_swap_with = AIHelper.cards_to_swap_with(card_to_swap).pick_random()
	card_to_swap.select_card(true)
	await get_tree().create_timer(0.5).timeout
	card_to_swap.swap_with_card(
		card_to_swap_with.card_owner_id, card_to_swap_with.card_in_play_index
	)

	Events.hide_instructions.emit()
	TargetSelection.end_selecting()
	Events.card_ability_resolved_for_ai.emit()
