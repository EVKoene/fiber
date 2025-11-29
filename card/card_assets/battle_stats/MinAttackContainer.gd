extends Node

class_name MinAttackContainer


func update_stat(value: int) -> void:
	$HBoxContainer/Label.text = str(value)
