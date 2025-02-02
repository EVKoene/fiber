extends HBoxContainer

class_name OptionContainer

var option_text: String
var option_index: int
var return_value: Variant


func _ready() -> void:
	$ChoiceTextPanel/CenterContainer/Label.text = option_text


func hide_option_indicator() -> void:
	$ChoicIndicatorPanel/CenterContainer/Label.text = ""


func show_option_indicator() -> void:
	$ChoicIndicatorPanel/CenterContainer/Label.text = ">"
