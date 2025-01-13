extends CanvasLayer

class_name OverworldTextboxMCOptions

@onready var textbox_container := $TextboxContainer
var option_container_scene: PackedScene = load("res://overworld/textbox/OptionContainer.tscn")

var options := []
var picking_options := false
var current_option_index := 0

signal option_picked(int)


func _ready() -> void:
	OverworldManager.mc_question_textbox = self


func pick_from_options(option_texts: Array) -> void:
	show()
	add_options(option_texts)
	picking_options = true
	options[current_option_index].show_option_indicator()


func add_options(option_texts: Array) -> void:
	for option_text in option_texts:
		var option_container := option_container_scene.instantiate()
		option_container.option_text = option_text
		options.append(option_container)
		$TextboxContainer/MarginContainer/OptionsContainer.add_child(option_container)


func indicate_lower_option() -> void:
	options[current_option_index].hide_option_indicator()
	if current_option_index == len(options) - 1:
		current_option_index = 0
	else:
		current_option_index += 1
	
	options[current_option_index].show_option_indicator()


func indicate_higher_option() -> void:
	options[current_option_index].hide_option_indicator()
	if current_option_index == 0:
		current_option_index = len(options) - 1
	else:
		current_option_index -= 1
	
	options[current_option_index].show_option_indicator()


func _cleanup_options() -> void:
	for c in $TextboxContainer/MarginContainer/OptionsContainer.get_children():
		c.queue_free()
	options = []
	picking_options = false
	hide()


func _input(_event):
	if !picking_options:
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		OverworldManager.overworld_textbox.cleanup_textbox()
		option_picked.emit(current_option_index)
		_cleanup_options()
	
	elif Input.is_action_just_pressed("ui_down"):
		indicate_lower_option()
	
	elif Input.is_action_just_pressed("ui_up"):
		indicate_higher_option()
		 
