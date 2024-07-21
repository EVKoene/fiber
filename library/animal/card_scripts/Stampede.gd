extends CardInPlay

class_name Stampede


func resolve_spell(_c_column: int, _c_row: int) -> bool:
	for c in GameManager.cards_in_play[card_owner_id]:
		c.battle_stats.change_max_attack(2, 2)
		c.battle_stats.change_min_attack(2, 2)
		c.battle_stats.change_health(2, 2)
		c.battle_stats.change_movement(1, 2)
		c.update_stats()

	return true


func resolve_spell_for_ai() -> void:
	resolve_spell(-1, -1)
