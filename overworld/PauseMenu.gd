extends Control


var is_paused: bool = false: set = _set_is_paused


func show_pick_deck() -> void:
	$CenterContainer/DeckPicker.find_decks()
	$CenterContainer/PauseButtons.hide()
	$CenterContainer/DeckPicker.show()
	$CenterContainer/DeckPicker.set_current_decks()


func show_pause_menu() -> void:
	$CenterContainer/PauseButtons.show()
	$CenterContainer/DeckPicker.hide()


func _input(event):
	if (
		(Input.is_action_just_pressed("ui_cancel")) 
		and TargetSelection.making_selection
	):
		TargetSelection.end_selecting()
		Events.clear_paths.emit()

	elif event.is_action_pressed("pause_menu"):
		is_paused = !is_paused
		show_pause_menu()


func _set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused


func _on_resume_button_pressed():
	is_paused = false


func _on_quit_button_pressed():
	get_tree().quit()


func _on_pick_deck_pressed():
	show_pick_deck()
