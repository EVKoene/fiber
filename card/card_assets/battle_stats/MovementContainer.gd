extends Node

class_name MovementContainer


func update_stat(value: int) -> void:
	$HBoxContainer/Label.text = str(value)
