extends StaticBody2D

class_name Sign

@export var sign_text: Array


func read_sign_text() -> void:
	OverworldManager.overworld_textbox.read_text(sign_text)
	await Events.dialogue_finished
	OverworldManager.can_move = true
