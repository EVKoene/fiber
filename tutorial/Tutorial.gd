extends Node


enum tutorial_phases {
	INSTRUCTION_START, BATTLEMAP_EXPLANATION, BLUE_RED_SPACES, HOVER_CARD, PREVIEW_CARD, CARD_COST,
	CARD_ATTACK, CARD_HEALTH, RESOURCES, PLAY_CARD, FACTION_RESOURCES, MOVE_CARD, ATTACK_CARD,
	CONQUER_VICTORY_SPACES
}

@onready var play_space_arrow_scene: PackedScene = preload("res://map/play_space/PlaySpaceArrow.tscn")
var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
var is_awaiting_tutorial_input := false
var current_phase := tutorial_phases.INSTRUCTION_START

var arrow_size := Vector2(100, 100)
var current_arrows := []


func setup_tutorial() -> void:
	if !GameManager.players.has(1):
		GameManager.add_player(
			1, 1, "Player1", DeckCollection.tutorial_deck
		)
	GameManager.player_id = 1

	GameManager.add_player(2, 2, "Tutorial", DeckCollection.nature_starter)
	
	GameManager.main_menu.hide_main_menu()
	var b_map = battle_map_scene.instantiate()
	b_map.is_tutorial = true
	GameManager.main_menu.add_child(b_map, true)


func start_tutorial() -> void:
	GameManager.battle_map.set_tutorial_container()
	GameManager.battle_map.show_tutorial_text(
		"Welcome to Fiber! In this tutorial you will learn the basics on how to play the game.\n
		Click to continue."
		)
	pause_battlemap_children()
	current_phase = tutorial_phases.BATTLEMAP_EXPLANATION
	is_awaiting_tutorial_input = true


func _battlemap_explanation() -> void:
	is_awaiting_tutorial_input = false
	GameManager.battle_map.show_tutorial_text(
		"This is the battlefield, consisting of 5 rows and 7 columns."
	)
	var arrow_position := Vector2(
		MapSettings.play_area_end.x - arrow_size.x * 0.5,
		MapSettings.total_screen.y / 2
	)
	_create_arrow(arrow_position, 180)
	pause_battlemap_children()
	current_phase = tutorial_phases.BLUE_RED_SPACES
	is_awaiting_tutorial_input = true


func _blue_red_spaces() -> void:
	is_awaiting_tutorial_input = false
	GameManager.battle_map.show_tutorial_text(
		"You can play your units on the blue spaces.\n Your opponent can play their units on the 
		red spaces."
	)
	var arrow_position_x := MapSettings.get_column_start_x(5) + arrow_size.x * 1.5
	var blue_arrow_position := Vector2(arrow_position_x, MapSettings.card_in_hand_size.y * 3)
	var red_arrow_position := Vector2(
		arrow_position_x, MapSettings.total_screen.y - MapSettings.card_in_hand_size.y
	)
	_create_arrow(blue_arrow_position, 180)
	_create_arrow(red_arrow_position, 180)
	pause_battlemap_children()
	current_phase = tutorial_phases.HOVER_CARD
	is_awaiting_tutorial_input = true


func _hover_card() -> void:
	is_awaiting_tutorial_input = false
	GameManager.battle_map.show_tutorial_text(
		"Try hovering a card in your hand.\n"
	)
	var arrow_position_y := MapSettings.play_area_end.y - arrow_size.y
	for c in GameManager.cards_in_hand[GameManager.player_id]:
		var arrow_position_x = c.position.x + arrow_size.x
		var arrow_position := Vector2(arrow_position_x, arrow_position_y)
		_create_arrow(arrow_position, 90)
	pause_battlemap_children()
	current_phase = tutorial_phases.PREVIEW_CARD


func _preview_card() -> void:
	is_awaiting_tutorial_input = false
	GameManager.battle_map.show_tutorial_text(
		"When you hover cards in your hand or on the battlefield you'll see a preview in the upper 
		right corner."
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x - GameManager.zoom_preview.size.x / 4,
		GameManager.zoom_preview.position.y + GameManager.zoom_preview.size.y / 2
	)
	_create_arrow(arrow_position, 0)
	pause_battlemap_children()
	current_phase = tutorial_phases.CARD_COST
	is_awaiting_tutorial_input = true


func _card_cost() -> void:
	is_awaiting_tutorial_input = false
	GameManager.battle_map.show_tutorial_text(
		"In the upper right corner of a card you'll find it's costs. This gorilla will cost 1 
		passion (red) resource to play."
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x + GameManager.zoom_preview.size.x * 1.25,
		GameManager.zoom_preview.position.y + GameManager.zoom_preview.size.y
	)
	_create_arrow(arrow_position, 270)
	pause_battlemap_children()
	current_phase = tutorial_phases.CARD_ATTACK
	is_awaiting_tutorial_input = true


func pause_battlemap_children() -> void:
	for c in GameManager.battle_map.get_children():
		c.process_mode = PROCESS_MODE_DISABLED


func unpause_battlemap_children() -> void:
	for c in GameManager.battle_map.get_children():
		c.process_mode = PROCESS_MODE_INHERIT



func _create_arrow(arrow_position: Vector2, arrow_rotation_degrees: int) -> void:
	var arrow = play_space_arrow_scene.instantiate()
	arrow.position.x = arrow_position.x
	arrow.position.y = arrow_position.y
	arrow.scale *= arrow_size / arrow.size
	arrow.rotation_degrees = arrow_rotation_degrees
	current_arrows.append(arrow)
	GameManager.battle_map.add_child(arrow)


func continue_tutorial() -> void:
	for a in current_arrows:
		a.queue_free()
	current_arrows = []
	unpause_battlemap_children()
	match current_phase:
		tutorial_phases.BATTLEMAP_EXPLANATION:
			_battlemap_explanation()
		tutorial_phases.BLUE_RED_SPACES:
			_blue_red_spaces()
		tutorial_phases.HOVER_CARD:
			_hover_card()
		tutorial_phases.PREVIEW_CARD:
			_preview_card()
		tutorial_phases.CARD_COST:
			_card_cost()
		
