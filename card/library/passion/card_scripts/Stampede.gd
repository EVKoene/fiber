extends CardInPlay

class_name Stampede


func resolve_spell() -> bool:
	for c in GameManager.cards_in_play[card_owner_id]:
		for stat in [
			Collections.stats.MAX_ATTACK, Collections.stats.MIN_ATTACK, Collections.stats.HEALTH
		]:
			CardManipulation.change_battle_stat(stat, card_owner_id, card_in_play_index, 2, 2)

		c.battle_stats.change_battle_stat(
			Collections.stats.MOVEMENT, card_owner_id, card_in_play_index, 1, 2
		)

	BattleSynchronizer.finish_resolve()
	return true


func resolve_spell_for_ai() -> void:
	resolve_spell()
	Events.spell_resolved_for_ai.emit()
	BattleSynchronizer.finish_resolve()


func is_spell_to_play_now() -> bool:
	var n_fresh_cards := 0
	for c in GameManager.cards_in_play[card_owner_id]:
		if !c.exhausted:
			n_fresh_cards += 1

	if n_fresh_cards >= 2:
		return true

	return false
