class_name BattleMapUI

var parent: BattleMap
var end_turn_button_container: PanelContainer
var finish_button_container: PanelContainer
var showing_finish_button := false

var highlight_instruction_container_tween: Tween
var highlight_finish_button_tween: Tween
var showing_instruction := false
var instruction_container: PanelContainer
var gold_gained_container: PanelContainer
var battle_zoom_preview: ZoomPreview
var card_text_container: PanelContainer

var resource_bar_scene: PackedScene


func _init(battle_map: BattleMap) -> void:
	parent = battle_map
	resource_bar_scene = preload("res://player/ResourceBar.tscn")


func set_end_turn_button() -> void:
	end_turn_button_container = parent.get_node("EndTurnButtonContainer")
	end_turn_button_container.size.x = MapSettings.total_screen.x / 10
	end_turn_button_container.size.y = MapSettings.total_screen.y / 10
	end_turn_button_container.position.x = MapSettings.total_screen.x - end_turn_button_container.size.x
	end_turn_button_container.position.y = MapSettings.total_screen.y - end_turn_button_container.size.y
	MapSettings.end_turn_button_size = end_turn_button_container.size
	end_turn_button_container.get_node("EndTurnButton").text = "End your turn!"


func hide_finish_button() -> void:
	showing_finish_button = false
	parent.get_node("FinishButtonContainer").hide()


func show_finish_button() -> void:
	showing_finish_button = true
	_tween_highlight_finish_button()
	parent.get_node("FinishButtonContainer").show()


func set_finish_button() -> void:
	finish_button_container = parent.get_node("FinishButtonContainer")
	finish_button_container.get_node("FinishButton").text = "Finish"
	finish_button_container.size.y = end_turn_button_container.size.y
	finish_button_container.size.x = end_turn_button_container.size.x
	finish_button_container.position.x = (
		MapSettings.total_screen.x
		- end_turn_button_container.size.x
		- finish_button_container.size.x
	)
	finish_button_container.get_theme_stylebox("panel").set_border_width_all(
		finish_button_container.size.x / 15
	)
	finish_button_container.position.y = MapSettings.total_screen.y - finish_button_container.size.y


func show_resolve_spell_button() -> void:
	parent.get_node("ResolveSpellButton").show()


func set_resolve_spell_button() -> void:
	var button = parent.get_node("ResolveSpellButton")
	button.text = "Resolve"
	button.custom_minimum_size.y = MapSettings.play_space_size.y / 2
	button.custom_minimum_size.x = MapSettings.play_space_size.x
	button.position.x = MapSettings.total_screen.x - MapSettings.play_space_size.x
	button.position.y = MapSettings.total_screen.y * 0.8


func set_zoom_preview_position_and_size() -> void:
	var zoom_preview_size: Vector2 = Vector2(
		MapSettings.total_screen.x * 0.2, MapSettings.total_screen.x * 0.2
	)
	var zoom_preview = parent.get_node("BattleZoomPreview")
	zoom_preview.position.x = MapSettings.total_screen.x - zoom_preview_size.x * 1.05
	zoom_preview.position.y = MapSettings.play_area_start.y
	zoom_preview.scale.x *= zoom_preview_size.x / zoom_preview.size.x
	zoom_preview.scale.y *= zoom_preview_size.x / zoom_preview.size.y
	MapSettings.zoom_preview_size = zoom_preview_size
	GameManager.zoom_preview = zoom_preview
	battle_zoom_preview = zoom_preview


func set_resource_bars_position_and_size() -> void:
	var rb_1 = resource_bar_scene.instantiate()
	var rb_2 = resource_bar_scene.instantiate()

	match GameManager.is_player_1:
		true:
			rb_1.position.y = (
				MapSettings.total_screen.y
				- MapSettings.resource_bar_size.y
				- MapSettings.end_turn_button_size.y
			)
			rb_2.position.y = 0
		false:
			rb_2.position.y = (
				MapSettings.total_screen.y
				- MapSettings.resource_bar_size.y
				- MapSettings.end_turn_button_size.y
			)
			rb_1.position.y = 0

	for rb in [rb_1, rb_2]:
		rb.position.x = MapSettings.total_screen.x - MapSettings.resource_bar_size.x
		rb.scale.x *= MapSettings.resource_bar_size.x / rb.size.x
		rb.scale.y *= MapSettings.resource_bar_size.y / rb.size.y

	GameManager.resource_bars[GameManager.p1_id] = rb_1
	GameManager.resource_bars[GameManager.p2_id] = rb_2
	parent.add_child(rb_1)
	parent.add_child(rb_2)


func hide_instructions() -> void:
	showing_instruction = false
	parent.get_node("InstructionContainer").hide()


func show_instructions(instruction_text: String) -> void:
	showing_instruction = true
	_tween_highlight_instruction_container()
	parent.get_node("InstructionContainer/InstructionText").text = instruction_text
	parent.get_node("InstructionContainer").show()


func set_text_containers() -> void:
	var text_box = parent.get_node("TextBox")
	text_box.size = MapSettings.total_screen
	_set_gold_gained_container()
	_set_instruction_container()
	_set_card_text_container()


func update_gold_container_text(gold_gained: int, turns_until_increase: int) -> void:
	if turns_until_increase == -1:
		parent.get_node("GoldGainedContainer/GoldGained").text = str("Gold gained: ", gold_gained)
	else:
		parent.get_node("GoldGainedContainer/GoldGained").text = str(
			"Gold gained: ", gold_gained, "\nTurns until increase: ", turns_until_increase
		)


func _set_gold_gained_container() -> void:
	gold_gained_container = parent.get_node("GoldGainedContainer")
	gold_gained_container.size.x = MapSettings.play_space_size.x * 2.5
	gold_gained_container.size.y = MapSettings.total_screen.y / 30
	gold_gained_container.get_node("GoldGained").label_settings.font_size = (
		round(MapSettings.play_space_size.x) / 15
	)
	gold_gained_container.position.x = MapSettings.total_screen.x - gold_gained_container.size.x
	gold_gained_container.position.y = (
		MapSettings.total_screen.y
		- MapSettings.resource_bar_size.y
		- MapSettings.end_turn_button_size.y
		- gold_gained_container.size.y
	)
	update_gold_container_text(0, 1)


func _set_instruction_container() -> void:
	assert(gold_gained_container != null, "Gold Gained container size not set yet")
	var ic = parent.get_node("InstructionContainer")
	ic.size.x = gold_gained_container.size.x
	ic.size.y = gold_gained_container.size.y * 6
	ic.position.x = MapSettings.total_screen.x - ic.size.x
	ic.position.y = (
		MapSettings.total_screen.y
		- MapSettings.resource_bar_size.y
		- MapSettings.end_turn_button_size.y
		- gold_gained_container.size.y
		- ic.size.y
	)
	ic.get_node("InstructionText").label_settings = LabelSettings.new()
	ic.get_node("InstructionText").label_settings.font_size = (
		round(MapSettings.play_space_size.x) / 10
	)
	instruction_container = ic

	instruction_container.get_theme_stylebox("panel").set_border_width_all(
		instruction_container.size.x / 15
	)


func _set_card_text_container() -> void:
	assert(battle_zoom_preview != null, "ZoomPreview container size not set yet")
	card_text_container = parent.get_node("CardTextContainer")
	battle_zoom_preview.card_text_container = card_text_container
	card_text_container.size.x = battle_zoom_preview.size.x
	card_text_container.size.y = battle_zoom_preview.size.y
	card_text_container.position.x = battle_zoom_preview.position.x
	card_text_container.position.y = battle_zoom_preview.position.y + battle_zoom_preview.size.y + card_text_container.size.y


func _tween_highlight_instruction_container() -> void:
	if !showing_instruction:
		return

	if highlight_instruction_container_tween:
		highlight_instruction_container_tween.kill()
	highlight_instruction_container_tween = parent.create_tween()
	var ic_stylebox: StyleBox = instruction_container.get_theme_stylebox("panel")
	highlight_instruction_container_tween.tween_property(
		ic_stylebox, "border_color", Color("d75c27"), 1
	)
	highlight_instruction_container_tween.tween_callback(_tween_unhighlight_instruction_container)


func _tween_unhighlight_instruction_container() -> void:
	if !showing_instruction:
		return

	if highlight_instruction_container_tween:
		highlight_instruction_container_tween.kill()
	highlight_instruction_container_tween = parent.create_tween()
	var ic_stylebox: StyleBox = instruction_container.get_theme_stylebox("panel")
	highlight_instruction_container_tween.tween_property(
		ic_stylebox, "border_color", Color("030000"), 1
	)
	highlight_instruction_container_tween.tween_callback(_tween_highlight_instruction_container)


func _tween_highlight_finish_button() -> void:
	if !showing_finish_button:
		return

	if highlight_finish_button_tween:
		highlight_finish_button_tween.kill()
	highlight_finish_button_tween = parent.create_tween()
	var finish_button_stylebox: StyleBox = finish_button_container.get_theme_stylebox("panel")
	highlight_finish_button_tween.tween_property(
		finish_button_stylebox, "border_color", Color("d75c27"), 1
	)
	highlight_finish_button_tween.tween_callback(_tween_unhighlight_finish_button)


func _tween_unhighlight_finish_button() -> void:
	if !showing_finish_button:
		return

	if highlight_finish_button_tween:
		highlight_finish_button_tween.kill()
	highlight_finish_button_tween = parent.create_tween()
	var finish_button_stylebox: StyleBox = finish_button_container.get_theme_stylebox("panel")
	highlight_finish_button_tween.tween_property(
		finish_button_stylebox, "border_color", Color("030000"), 1
	)
	highlight_finish_button_tween.tween_callback(_tween_highlight_finish_button)
