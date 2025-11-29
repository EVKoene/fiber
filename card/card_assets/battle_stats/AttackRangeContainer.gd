extends Node

class_name AttackRangeContainer


func update_stat(value: int) -> void:
	$HBoxContainer/Label.text = str(value)
