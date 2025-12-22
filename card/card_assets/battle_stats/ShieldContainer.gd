extends PanelContainer

class_name ShieldContainer


@onready var border := StyleBoxFlat.new()
var has_border := false

func update_stat(value: int) -> void:
	$HBoxContainer/Label.text = str(value)


func highlight_stat() -> void:
	if has_border:
		return
	
	has_border = true
	
	border.border_color = Styling.gold_color
	var border_width := size.x * 0.1
	border.set_border_width_all(border_width)
	border.set_content_margin_all(1)
	border.set_expand_margin_all(border_width)
	add_theme_stylebox_override("panel", border)


func hide_border() -> void:
	if !has_border:
		return
	
	has_border = false
	
	remove_theme_stylebox_override("panel")
