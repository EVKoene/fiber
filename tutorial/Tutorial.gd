extends Node


enum tutorial_phases {INSTRUCTION_LOCATION, PLAY_CARD}

@onready var play_space_arrow_scene: PackedScene = preload("res://map/play_space/PlaySpaceArrow.tscn")
var is_awaiting_tutorial_input := false
var current_phase := tutorial_phases.PLAY_CARD

var arrow_size := Vector2(100, 100)


func _start_tutorial() -> void:
	GameManager.battle_map.show_text(
		"Welcome to Fiber! In this tutorial you will learn the basics of how to play the game..
		"
		)
	is_awaiting_tutorial_input = true


func _create_arrow(arrow_position: Vector2, arrow_rotation_degrees: int) -> void:
	var arrow = play_space_arrow_scene.instantiate()
	arrow.position.x = arrow_position.x
	arrow.position.y = arrow_position.y
	arrow.scale *= arrow_size / arrow.size
	arrow.rotation_degrees = arrow_rotation_degrees
	GameManager.battle_map.add_child(arrow)


func _instruction_location() -> void:
	is_awaiting_tutorial_input = false
	GameManager.battle_map.show_instructions(
		"You will find the instructions right here. Click to continue the tutorial."
	)
	var arrow_position := Vector2(
		GameManager.battle_map.instruction_container.position.x - arrow_size.x * 1.5,
		GameManager.battle_map.instruction_container.position.y
	)
	_create_arrow(arrow_position, 0)
	is_awaiting_tutorial_input = true


func continue_tutorial() -> void:
	match current_phase:
		tutorial_phases.INSTRUCTION_LOCATION:
			_instruction_location()
