class_name BattleMapText

var parent: BattleMap
var is_showing_text := false
var tutorial_container: PanelContainer


func _init(battle_map: BattleMap) -> void:
	parent = battle_map


func show_text(text_to_show: String) -> void:
	parent.get_tree().paused = true
	parent.get_node("TextBox/Panel/Label").text = text_to_show
	parent.get_node("TextBox").show()
	is_showing_text = true


func hide_text() -> void:
	parent.get_node("TextBox").hide()
	is_showing_text = false
	parent.text_dismissed.emit()
	if GameManager.ai_player and GameManager.ai_player.showing_boss_text:
		GameManager.ai_player.showing_boss_text = false
		GameManager.ai_player.use_boss_ability()


func set_tutorial_container() -> void:
	tutorial_container = parent.get_node("TutorialContainer")
	tutorial_container.position.x = MapSettings.total_screen.x / 2 - tutorial_container.size.x
	tutorial_container.position.y = MapSettings.total_screen.y / 2 - tutorial_container.size.y / 2
	tutorial_container.move_to_front()


func hide_tutorial_text() -> void:
	parent.get_node("TutorialContainer").hide()


func show_tutorial_text(tutorial_text: String) -> void:
	parent.get_node("TutorialContainer/TutorialText").text = tutorial_text
	parent.get_node("TutorialContainer").show()
