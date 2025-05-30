extends PanelContainer


class_name CardTextContainer

@onready var card_text_label = $CardText
var card_text: String


func set_card_text(new_text: String) -> void:
	card_text = new_text
	set_card_text_font_size()
	$CardText.text = card_text


func set_card_text_font_size() -> void:
	if !$CardText.label_settings:
		$CardText.label_settings = LabelSettings.new()
	var min_font: float = size.x / 22
	var max_font: float = size.x / 15
	var max_line_count: float = 6.0
	var font_range_diff: float = max_font - min_font
	var font_change_per_line: float = font_range_diff / (max_line_count - 1)
	var card_text_font_size: float
	if card_text == "":
		card_text_font_size = max_font
	else:
		card_text_font_size = (max_font - CardHelper.calc_n_lines(card_text) * font_change_per_line)

	$CardText.label_settings.font_size = card_text_font_size
