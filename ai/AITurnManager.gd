extends Node

class_name AITurnManager


func start_turn() -> void:
	GameManager.battle_map.show_text("Playing opponents turn")
	await GameManager.battle_map.get_tree().create_timer(0.5).timeout
	GameManager.battle_map.hide_text()
	await GameManager.battle_map.get_tree().create_timer(0.25).timeout
	GameManager.turn_manager.start_turn(GameManager.ai_player_id)


func end_turn() -> void:
	GameManager.battle_map.show_text("Opponents turn finished")
	await GameManager.battle_map.get_tree().create_timer(0.25).timeout
	GameManager.turn_manager.show_start_turn_text()
