extends CardInPlay

class_name StreamOfThought


func resolve_spell() -> bool:
	Events.show_instructions.emit("Pick an opponent unit")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OPPONENT_UNITS, null, false, 2, true
	)
	await TargetSelection.target_selection_finished
	var selected_card: CardInPlay
	if len(TargetSelection.selected_targets) == 1:
		selected_card = TargetSelection.selected_targets[0]
	else:
		BattleSynchronizer.finish_resolve()
		return false

	selected_card.highlight_card(true)
	selected_card.resolve_damage(4)
	BattleSynchronizer.draw_card(card_owner_id)
	BattleSynchronizer.finish_resolve()
	return true


func is_spell_to_play_now() -> bool:
	for c in CardHelper.cards_in_range(
		GameManager.ai_player_id, 2, TargetSelection.target_restrictions.OPPONENT_UNITS
	):
		if c.battle_stats.health <= 4:
			return true

	return false


func resolve_spell_for_ai() -> void:
	var targets: Array = []
	for c in CardHelper.cards_in_range(
		GameManager.ai_player_id, 2, TargetSelection.target_restrictions.OPPONENT_UNITS
	):
		if c.battle_stats.health <= 4:
			targets.append(c)

	assert(
		len(targets) > 0,
		str("No targets to select, AI shouldn't have played this spell: ", ingame_name)
	)
	var target: CardInPlay = targets.pick_random()
	target.highlight_card(true)
	await target.resolve_damage(4)
	BattleSynchronizer.draw_card(card_owner_id)
	Events.spell_resolved_for_ai.emit()
	BattleSynchronizer.finish_resolve()
