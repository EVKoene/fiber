extends Node

class_name ShieldContainer


func update_stat(value: int) -> void:
	var value_text := "-"
	if value != 0:
		value_text = str(value)
	
	$HBoxContainer/Label.text = value_text
