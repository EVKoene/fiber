extends Node

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	color_rect.visible = false


func transition_to_npc_battle(npc_id: int) -> void:
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	GameManager.main_menu.remove_child(GameManager.main_menu.current_area)
	GameManager.main_menu.start_single_player_battle(npc_id)
	animation_player.play_backwards("fade_scene")


func reload_scene() -> void:
	animation_player.play("fade_scene")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play_backwards("fade_scene")
