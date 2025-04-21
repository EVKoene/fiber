extends CardInPlay

class_name StudentOfKhong


func prepare_attack() -> void:
	CardManipulation.change_battle_stat(
		Collections.stats.MAX_ATTACK, card_owner_id, card_in_play_index, 1, battle_stats.health
	)
