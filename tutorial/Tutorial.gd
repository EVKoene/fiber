extends Node


enum tutorial_phases {PLAY_CARD}
var current_phase := tutorial_phases.PLAY_CARD

func _start_tutorial() -> void:
	GameManager.battle_map.show_text(
		"Welcome to Fiber! In this tutorial you will learn the basics of how to play the game..
		"
		)

func play_cards() -> void:
	pass


func continue_tutorial() -> void:
	match current_phase:
		tutorial_phases.PLAY_CARD:
			
