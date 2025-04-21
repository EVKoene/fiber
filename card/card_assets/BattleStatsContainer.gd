extends PanelContainer


class_name BattleStatsContainer


func update_stat(battle_stat: int, value: int) -> void:
	var value_text: String
	if value > 0:
		value_text = str(value)
	else:
		value_text = "-"
	
	match battle_stat:
		Collections.stats.ATTACK_RANGE:
			$HBoxContainer/AttackRangeContainer/AttackRangeLabel.text = value_text
		Collections.stats.HEALTH:
			$HBoxContainer/HealthContainer/HealthLabel.text = value_text
		Collections.stats.MAX_ATTACK:
			$HBoxContainer/MaxAttackContainer/MaxAttackLabel.text = value_text
		Collections.stats.MIN_ATTACK:
			$HBoxContainer/MinAttackContainer/MinAttackLabel.text = value_text
		Collections.stats.MOVEMENT:
			$HBoxContainer/MovementContainer/MovementLabel.text = value_text
		Collections.stats.SHIELD:
			$HBoxContainer/ShieldContainer/ShieldLabel.text = value_text
