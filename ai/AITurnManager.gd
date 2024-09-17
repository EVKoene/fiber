extends Node

class_name AITurnManager


func start_turn() -> void:
	GameManager.battle_map.show_text("Playing opponents turn")
	GameManager.battle_map.get_tree().create_timer(1).timeout
	GameManager.battle_map.hide_text()
	GameManager.turn_manager.start_turn(GameManager.p1_id)

