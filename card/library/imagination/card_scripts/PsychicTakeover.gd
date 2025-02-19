extends CardInPlay

class_name PsychicTakeover


func resolve_spell() -> bool:
	Events.show_instructions.emit("Pick an opponent unit")
	TargetSelection.select_targets(
		1, TargetSelection.target_restrictions.OPPONENT_UNITS, null, false, 1, true
	)
	await TargetSelection.target_selection_finished
	var selected_card: CardInPlay
	if len(TargetSelection.selected_targets) == 1:
		selected_card = TargetSelection.selected_targets[0]
	else:
		BattleSynchronizer.finish_resolve()
		return false

	selected_card.highlight_card(true)
	selected_card.card_owner_id = card_owner_id
	if (
		(GameManager.is_player_1 and card_owner_id == GameManager.p2_id)
		or (!GameManager.is_player_1 and card_owner_id == GameManager.p1_id)
	):
		selected_card.flip_card()
	else:
		selected_card.unflip_card()

	BattleSynchronizer.finish_resolve()
	return true


func is_spell_to_play_now() -> bool:
	for c in CardHelper.cards_in_range(
		GameManager.ai_player_id, 1, TargetSelection.target_restrictions.OPPONENT_UNITS
	):
		if c.costs.total() >= 3:
			return true

	return false


func resolve_spell_for_ai() -> void:
	var targets: Array = []
	for c in CardHelper.cards_in_range(
		GameManager.ai_player_id, 1, TargetSelection.target_restrictions.OPPONENT_UNITS
	):
		if c.costs.total() >= 3:
			targets.append(c)

	assert(
		len(targets) > 0,
		str("No targets to select, AI shouldn't have played this spell: ", ingame_name)
	)
	var target: CardInPlay = targets.pick_random()
	target.highlight_card(true)
	target.card_owner_id = card_owner_id
	GameManager.cards_in_play[GameManager.player_id].erase(target)
	GameManager.cards_in_play[card_owner_id].append(target)
	if (
		(GameManager.is_player_1 and card_owner_id == GameManager.p2_id)
		or (!GameManager.is_player_1 and card_owner_id == GameManager.p1_id)
	):
		target.flip_card()
	else:
		target.unflip_card()
	Events.spell_resolved_for_ai.emit()
	BattleSynchronizer.finish_resolve()
