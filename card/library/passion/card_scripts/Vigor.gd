extends CardInPlay


class_name Vigor

func resolve_spell() -> bool:
	for c in GameManager.cards_in_play[card_owner_id]:
		CardManipulation.change_battle_stat(
			Collections.stats.MOVEMENT, c.card_owner_id, c.card_in_play_index, 1, 2
		)
		CardManipulation.change_battle_stat(
				Collections.stats.MAX_ATTACK, c.card_owner_id, c.card_in_play_index, 1, 2
			)
	BattleSynchronizer.finish_resolve()
	return true


func resolve_spell_for_ai() -> void:
	resolve_spell()
	Events.spell_resolved_for_ai.emit()
	BattleSynchronizer.finish_resolve()


func is_spell_to_play_now() -> bool:
	if len(GameManager.cards_in_hand[GameManager.ai_player_id]) >= 2:
		return true
	
	return false
