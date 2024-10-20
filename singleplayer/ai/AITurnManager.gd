extends Node

class_name AITurnManager


func start_turn() -> void:
	GameManager.lobby.battle_map.show_text("Playing opponents turn")
	await GameManager.lobby.battle_map.get_tree().create_timer(0.5).timeout
	GameManager.lobby.battle_map.hide_text()
	await GameManager.lobby.battle_map.get_tree().create_timer(0.25).timeout
	GameManager.lobby.turn_manager.start_turn(GameManager.lobby.ai_player_id)


func end_turn() -> void:
	await GameManager.lobby.battle_map.get_tree().create_timer(0.25).timeout
	GameManager.lobby.turn_manager.show_start_turn_text()
