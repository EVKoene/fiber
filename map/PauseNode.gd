extends Node


func _input(event: InputEvent) -> void:
	if (
		Input.is_action_just_pressed("pause") 
		or (
			event is InputEventMouseButton 
			and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
		)
	):
		if get_tree().paused:
			get_tree().paused = false
			GameManager.battle_map.hide_text()
