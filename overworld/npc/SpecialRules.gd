extends Node


func add_stat(stat: int, value: int) -> void:
	GameManager.battle_map.show_instructions(
		str(
			"This is a boss battle! All enemy units will have ", value, "extra ", 
			str(Collections.stat_names[stat])
		)
	)
	for ps in GameManager.play_spaces:
		ps.stat_modifier[GameManager.ai_player_id][Collections.stats.MAX_ATTACK] += 1
	
	await Events.instruction_input_received
