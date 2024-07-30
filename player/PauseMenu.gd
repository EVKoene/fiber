extends Control


var is_paused: bool = false: set = _set_is_paused


func _unhandled_input(event):
	if (
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.pressed
	):
		TargetSelection.end_selecting()


func _input(event):
	if Input.is_action_just_pressed("ui_cancel") and TargetSelection.making_selection:
		TargetSelection.end_selecting()
		Events.clear_paths.emit()

	elif event.is_action_pressed("pause"):
		is_paused = !is_paused


func _set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused


func _on_resume_button_pressed():
	is_paused = false


func _on_quit_button_pressed():
	get_tree().quit()
