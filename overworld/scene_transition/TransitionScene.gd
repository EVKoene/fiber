extends Node

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
@onready var deck_builder_scene := load("res://deckbuilder/Deckbuilder.tscn")
@onready var deck_picker_scene := load("res://deckbuilder/DeckPicker.tscn")
@onready var start_journey_scene := load("res://overworld/areas/StartOfJourney.tscn")


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
	area_id: int, to_exact_position := Vector2(-1, -1), text_after_transition := []
) -> void:
	if GameManager.current_scene:
		GameManager.current_scene.queue_free()
		GameManager.current_scene = null
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	
	animation_player.play_backwards("fade_scene")
	GameManager.testing = false
	OverworldManager.can_move = true
	var area_scenepath := load(AreaDatabase.get_area_scene(area_id))
	var area_scene = area_scenepath.instantiate()
	GameManager.main_menu.hide_main_menu()
	if to_exact_position == Vector2(-1, -1):
		area_scene.player_position = AreaDatabase.areas[area_id]["StartingPosition"]
	else:
		area_scene.player_position = to_exact_position
	GameManager.add_child(area_scene)
	GameManager.call_deferred("cleanup_game")
	if len(text_after_transition) != 0:
		GameManager.current_scene.call_deferred("read_text", text_after_transition)
		await Events.dialogue_finished
		OverworldManager.can_move = true
	
	OverworldManager.save_player_position()


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


func transition_to_start_journey() -> void:
	if GameManager.current_scene:
		GameManager.current_scene.queue_free()
		GameManager.current_scene = null
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	
	animation_player.play_backwards("fade_scene")
	GameManager.testing = false
	OverworldManager.can_move = true
	var start_journey = start_journey_scene.instantiate()
	start_journey.new_game = true
	GameManager.main_menu.hide_main_menu()
	start_journey.player_position = AreaDatabase.areas[
		AreaDatabase.area_ids.START_OF_JOURNEY
	]["StartingPosition"]
	GameManager.add_child(start_journey)
	GameManager.call_deferred("cleanup_game")
	OverworldManager.can_move = false
	OverworldManager.save_player_position()
	


func transition_to_tutorial() -> void:
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	GameManager.current_scene.queue_free()
	GameManager.current_scene = null
	Tutorial.setup_tutorial()
	animation_player.play_backwards("fade_scene")


func transition_to_test_battle() -> void:
	GameManager.add_player(
			1, 1, "Player1", DeckCollection.decks[DeckCollection.deck_ids.PLAYER_TESTING]
		)
	GameManager.player_id = 1

	GameManager.add_player(
		2, 2, "TestHarry", DeckCollection.decks[DeckCollection.deck_ids.OPPONENT_TESTING], 2
	)
	GameManager.start_game()
