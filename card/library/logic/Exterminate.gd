extends CardInPlay

class_name Exterminate


func resolve_spell() -> bool:
	Events.show_instructions.emit("Pick one of your units")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, null, false, -1, true
	)
	await TargetSelection.target_selection_finished
	var selected_card: CardInPlay
	if len(TargetSelection.selected_targets) == 1:
		selected_card = TargetSelection.selected_targets[0]
	else:
		BattleSynchronizer.finish_resolve()
		return false

	Events.show_instructions.emit("Choose a unit to destroy")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.ANY_UNITS, selected_card, false, 1, true
	)
	selected_card.select_card(true)
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
		var card_to_destroy: CardInPlay = TargetSelection.selected_targets[0]
		selected_card.destroy()
		card_to_destroy.destroy()
		BattleSynchronizer.finish_resolve()
		return true

	else:
		BattleSynchronizer.finish_resolve()
		return false


func is_spell_to_play_now() -> bool:
	for c in GameManager.cards_in_play[card_owner_id]:
		for ps in c.spaces_in_range(1, card_owner_id):
			if (
				!ps.card_in_this_play_space
				or ps.card_in_this_play_space.card_owner_id == card_owner_id
			):
				continue
			elif ps.card_in_this_play_space.costs.total() > costs.total():
				return true

	return false


func resolve_spell_for_ai() -> void:
	for c in GameManager.cards_in_play[card_owner_id]:
		for ps in c.spaces_in_range(c.current_play_space, card_owner_id, 1):
			if (
				!ps.card_in_this_play_space
				or ps.card_in_this_play_space.card_owner_id == card_owner_id
			):
				continue
			elif ps.card_in_this_play_space.costs.total() > costs.total():
				c.destroy()
				ps.card_in_this_play_space.destroy()
				Events.spell_resolved_for_ai.emit()
				BattleSynchronizer.finish_resolve()
				return

	assert(false, "AIPlayer couldn't find a correct target to play exterminate on")
