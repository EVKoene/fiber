extends HBoxContainer


class_name OptionContainer


var option_text: String
var option_index: int

func _ready() -> void:
	$ChoiceTextPanel/CenterContainer/Label.text = option_text
