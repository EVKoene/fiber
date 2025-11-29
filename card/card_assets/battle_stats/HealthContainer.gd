extends Node

class_name HealthContainer


func update_stat(value: int) -> void:
	$HBoxContainer/Label.text = str(value)
