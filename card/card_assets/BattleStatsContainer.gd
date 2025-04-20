extends PanelContainer


class_name BattleStatsContainer


func update_stat(battle_stat: int, value: int) -> void:
	match battle_stat:
		Collections.stats.ATTACK_RANGE:
			$HBoxContainer/AttackRangeContainer/AttackRangeLabel.text = str(value)
		Collections.stats.HEALTH:
			$HBoxContainer/HealthContainer/HealthLabel.text = str(value)
		Collections.stats.MAX_ATTACK:
			$HBoxContainer/MaxAttackContainer/MaxAttackLabel.text = str(value)
		Collections.stats.MIN_ATTACK:
			$HBoxContainer/MinAttackContainer/MinAttackLabel.text = str(value)
		Collections.stats.MOVEMENT:
			$HBoxContainer/MovementContainer/MovementLabel.text = str(value)
		Collections.stats.SHIELD:
			if value == 0:
				$HBoxContainer/ShieldContainer/ShieldLabel.text = "-"
			else:
				$HBoxContainer/ShieldContainer/ShieldLabel.text = str(value)
