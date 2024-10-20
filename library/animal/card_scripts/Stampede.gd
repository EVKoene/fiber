extends CardInPlay

class_name Stampede


func resolve_spell(_c_column: int, _c_row: int) -> bool:
	for c in GameManager.cards_in_play[card_owner_id]:
		for stat in [
			Collections.stats.MAX_ATTACK, Collections.stats.MIN_ATTACK, 
			Collections.stats.HEALTH
		]:
			CardManipulation.change_battle_stat(stat, card_owner_id, card_in_play_index, 2, 2)
		
		c.battle_stats.change_battle_stat(
			Collections.stats.MOVEMENT, card_owner_id, card_in_play_index, 1, 2
		)
	
	BattleManager.finish_resolve()
	return true


func resolve_spell_for_ai() -> void:
	resolve_spell(-1, -1)
	Events.spell_resolved_for_ai.emit()
	BattleManager.finish_resolve()
