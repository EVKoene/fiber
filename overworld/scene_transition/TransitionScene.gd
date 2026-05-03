extends Node

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
@onready var deck_builder_scene := load("res://deckbuilder/Deckbuilder.tscn")


func _ready():
	color_rect.visible = false


func transition_to_npc_battle(npc_id: int) -> void:
	GameManager.is_server = true
	animation_player.play("fade_scene")

	await animation_player.animation_finished
	if GameManager.current_scene:
		GameManager.current_scene.queue_free()
		GameManager.current_scene = null
	
	GameManager.start_single_player_battle(npc_id)
	animation_player.play_backwards("fade_scene")


func transition_to_deck_builder(deck_id: int) -> void:
	if GameManager.current_scene:
		GameManager.current_scene.queue_free()
	GameManager.main_menu.hide_main_menu()
	GameManager.current_scene = null
	var deck_builder = deck_builder_scene.instantiate()
	deck_builder.deck_id = deck_id
	GameManager.main_menu.add_child(deck_builder, true)


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


func transition_to_main_menu() -> void:
	GameManager.cleanup_game()
	if GameManager.current_scene:
		GameManager.current_scene.queue_free()
		GameManager.current_scene = null
	GameManager.main_menu.get_tree().paused = false
	GameManager.main_menu.show_main_menu()
