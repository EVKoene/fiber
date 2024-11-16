extends Node

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
@onready var deck_builder_scene := load("res://deckbuilder/Deckbuilder.tscn")

func _ready():
	color_rect.visible = false


func transition_to_npc_battle(npc_id: int) -> void:
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	GameManager.current_area.queue_free()
	GameManager.current_area = null
	GameManager.start_single_player_battle(npc_id)
	animation_player.play_backwards("fade_scene")


func transition_to_overworld() -> void:
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	GameManager.main_menu.call_deferred("go_to_overworld")
	
	animation_player.play_backwards("fade_scene")


func transition_to_deck_builder(deck_id: int) -> void:
	GameManager.current_area.queue_free()
	GameManager.current_area = null
	var deck_builder = deck_builder_scene.instantiate()
	GameManager.main_menu.add_child(deck_builder, true)


func reload_scene() -> void:
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play_backwards("fade_scene")
