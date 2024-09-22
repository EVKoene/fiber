extends CanvasLayer

var text_lines: Array = []
var line_count: int = 0
var in_dialogue = false


func _ready():
	Events.overworld_text_request.connect(show_text)


func show_text(npc_text_lines: Array) -> void:
	if !in_dialogue:
		text_lines = npc_text_lines
		show()
		Events.pause_player_movement.emit()
		$TextboxContainer/MarginContainer/HBoxContainer/Text.text = text_lines[0]
		await get_tree().create_timer(0.5).timeout
		in_dialogue = true
	
	
func _process(_delta):
	if (
		in_dialogue 
		and line_count < len(text_lines) - 1 
		and Input.is_action_just_pressed("ui_accept")
	):
		line_count += 1
		$TextboxContainer/MarginContainer/HBoxContainer/Text.text = text_lines[line_count]
	elif (
		in_dialogue
		and line_count == len(text_lines) - 1 
		and Input.is_action_just_pressed("ui_accept")
	):
		hide()
		line_count = 0
		text_lines = []
		in_dialogue = false
		Events.resume_player_movement.emit()
