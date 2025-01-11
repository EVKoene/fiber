extends CanvasLayer

class_name OverworldTextboxMCOptions

@onready var textbox_container := $TextboxContainer
var option_container: PackedScene = load("res://overworld/textbox/OptionContainer.tscn")

var options := []
var picking_options := false
var current_option_index := 0

signal option_picked(int)


func pick_from_options(option_texts: Array) -> void:
	add_options(option_texts)
	picking_options = true
	OverworldManager.can_move = false


func indicate_lower_option() -> void:
	pass

func add_options(option_texts: Array) -> void:
	for option_text in option_texts:
		options.append(option_text)
		var option_container := option_container.instantiate()
		option_container.option_text = option_text
		$TextboxContainer/MarginContainer/OptionsContainer.add_child(option_container)


func _cleanup_options() -> void:
	for c in $TextboxContainer/MarginContainer/OptionsContainer.get_children():
		c.queue_free()
	options = []
	picking_options = false


func _input(_event):
	if !picking_options:
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		_cleanup_options()
		option_picked.emit(current_option_index)
	
	elif Input.is_action_just_pressed("ui_down"):
		indicate_lower_option()
