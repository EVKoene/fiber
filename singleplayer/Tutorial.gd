extends Panel


class_name Tutorial


var current_slide := 0


func _next_slide() -> void:
	current_slide += 1
	if FileAccess.file_exists("res://assets/tutorial/tutorial_" + str(current_slide) + ".png"):
		$TutorialSlide.texture = load("res://assets/tutorial/tutorial_" + str(current_slide) + ".png")
	else:
		print("No such file: ", str("res://assets/tutorial/tutorial_" + str(current_slide) + ".png"))
		GameManager.main_menu.show_main_menu()
		queue_free()


func _input(_event):
	if (
		Input.is_action_just_pressed("ui_accept") 
		or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	):
		_next_slide()
