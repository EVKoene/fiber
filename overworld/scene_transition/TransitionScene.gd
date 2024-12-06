extends Node

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
@onready var deck_builder_scene := load("res://deckbuilder/Deckbuilder.tscn")
@onready var deck_picker_scene := load("res://deckbuilder/DeckPicker.tscn")

func _ready():
	color_rect.visible = false


func transition_to_npc_battle(npc_id: int) -> void:
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	GameManager.current_scene.queue_free()
	GameManager.current_scene = null
	GameManager.start_single_player_battle(npc_id)
	animation_player.play_backwards("fade_scene")


func transition_to_overworld_scene(
	area_id: int, coming_from_area_id := -1, text_after_transition := []) -> void:
	if GameManager.current_scene:
		GameManager.current_scene.queue_free()
		GameManager.current_scene = null
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	
	animation_player.play_backwards("fade_scene")
	if len(text_after_transition) != 0:
		GameManager.current_scene.read_text(text_after_transition)
	GameManager.testing = false
	OverworldManager.can_move = true
	var area_scenepath := load(AreaDatabase.get_area_scene(area_id))
	var area_scene = area_scenepath.instantiate()
	GameManager.main_menu.hide_main_menu()
	if coming_from_area_id != -1:
		area_scene.player_position = AreaDatabase.areas[
			area_id]["TransitionPosition"][coming_from_area_id
		]
	else:
		area_scene.player_position = AreaDatabase.areas[area_id]["StartingPosition"]
	GameManager.add_child(area_scene)
	




func transition_to_deck_builder(deck_id: int) -> void:
	GameManager.current_scene.queue_free()
	GameManager.current_scene = null
	var deck_builder = deck_builder_scene.instantiate()
	deck_builder.deck_id = deck_id
	GameManager.main_menu.add_child(deck_builder, true)


func reload_scene() -> void:
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play_backwards("fade_scene")
