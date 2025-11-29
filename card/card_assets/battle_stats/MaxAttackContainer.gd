extends Node

class_name MaxAttackContainer


func update_stat(value: int) -> void:
	$HBoxContainer/Label.text = str(value)
