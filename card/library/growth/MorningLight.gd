extends CardInPlay

class_name MorningLight


func resolve_spell() -> bool:
	Events.show_instructions.emit("Pick one of your units")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OWN_UNITS, null, false, -1, true
	)
	await TargetSelection.target_selection_finished
	if len(TargetSelection.selected_targets) == 1:
		var target: CardInPlay = TargetSelection.selected_targets[0]
		CardManipulation.change_battle_stat(
			Collections.stats.HEALTH, target.card_owner_id, target.card_in_play_index, 2, -1
		)
		CardManipulation.change_battle_stat(
			Collections.stats.MOVEMENT, target.card_owner_id, target.card_in_play_index, 1, -1
		)

		BattleSynchronizer.finish_resolve()
		return true

	BattleSynchronizer.finish_resolve()
	return false


func is_spell_to_play_now() -> bool:
	for c in GameManager.cards_in_play[GameManager.ai_player_id]:
		if c.costs.total() >= 3:
			return true

	return false


func resolve_spell_for_ai() -> void:
	var potential_targets: Array = AIHelper.find_cards_with_stat_from_options(
		GameManager.cards_in_play[card_owner_id],
		Collections.stats.TOTAL_COST,
		Collections.stat_params.HIGHEST,
		-1
	)

	assert(
		len(potential_targets) > 0,
		str("No targets to select, AI shouldn't have played this spell: ", ingame_name)
	)
	var target: CardInPlay = potential_targets.pick_random()
	CardManipulation.change_battle_stat(
		Collections.stats.HEALTH, target.card_owner_id, target.card_in_play_index, 2, -1
	)
	CardManipulation.change_battle_stat(
		Collections.stats.MOVEMENT, target.card_owner_id, target.card_in_play_index, 1, -1
	)
	Events.spell_resolved_for_ai.emit()
	BattleSynchronizer.finish_resolve()
