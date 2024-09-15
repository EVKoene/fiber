extends Panel

class_name CardPickScreen

@onready var card_option_scene := preload("res://card/card_states/CardOption.tscn")
var card_indices: Array 


func _ready():
	_add_card_options()


func _add_card_options() -> void:
	for c in len(card_indices):
		var card_option := card_option_scene.instantiate()
		card_option.size = MapSettings.card_option_size
		card_option.card_index = card_indices[c]
		card_option.option_index = c
		card_option.card_pick_screen = self
		card_option.card_owner_id = GameManager.player_id
		$HBox.add_child(card_option)
		if c != len(card_indices):
			var margin_container := MarginContainer.new()
			margin_container.add_theme_constant_override("margin_left", 40)
			$HBox.add_child(margin_container)
