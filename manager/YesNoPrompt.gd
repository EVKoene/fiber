extends PanelContainer

var prompt_text: String
var main_menu: MainMenu


func _ready():
	get_tree().paused = true
	set_text()


func set_text() -> void:
	$HBoxContainer/VBoxContainer/PromptText.text = prompt_text


func tear_down() -> void:
	get_tree().paused = false
	queue_free()
	main_menu.prompt_container.hide()


func _on_yes_button_pressed():
	Events.prompt_answer_positive.emit(true)
	tear_down()


func _on_no_button_pressed():
	Events.prompt_answer_positive.emit(false)
	tear_down()
