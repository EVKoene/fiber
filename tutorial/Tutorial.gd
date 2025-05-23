extends Node


enum tutorial_phases {
	INSTRUCTION_START, BATTLEMAP_EXPLANATION, BLUE_RED_SPACES, HOVER_CARD, PREVIEW_CARD, CARD_COST,
	CARD_MOVEMENT, CARD_ATTACK_RANGE, CARD_MAX_ATTACK, CARD_HEALTH, CARD_SHIELD, 
	RESOURCES, RESOURCE_REFRESH, PLAY_CARD, FACTION_RESOURCES, MOVE_CARD, ATTACK_CARD, EXHAUST, 
	ATTACK_FURTHER, CONQUER_VICTORY_SPACES, PROGRESS_BAR, USE_ABILITIES, SPELLS, 
	USE_ATTACK_COMMAND, END_TURN, FINISH_TUTORIAL
}

@onready var play_space_arrow_scene: PackedScene = preload("res://map/play_space/PlaySpaceArrow.tscn")
var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
var is_awaiting_tutorial_input := false
var next_phase := tutorial_phases.INSTRUCTION_START
var battle_map: BattleMap

var arrow_size := Vector2(100, 100)
var current_arrows := []


func setup_tutorial() -> void:
	if !GameManager.players.has(1):
		GameManager.add_player(
			1, 1, "Player1", DeckCollection.decks[DeckCollection.deck_ids.TUTORIAL_DECK]
		)
	GameManager.player_id = 1

	GameManager.add_player(2, 2, "Tutorial", DeckCollection.decks[DeckCollection.deck_ids.GROWTH_STARTER])
	
	GameManager.main_menu.hide_main_menu()
	GameManager.testing = false
	var b_map = battle_map_scene.instantiate()
	GameManager.current_scene = b_map
	b_map.is_tutorial = true
	GameManager.main_menu.add_child(b_map, true)


func start_tutorial() -> void:
	GameManager.turn_manager.turn_owner_id = GameManager.player_id
	GameManager.is_ready_to_play = true
	battle_map = GameManager.battle_map
	battle_map.end_turn_button_container.hide()
	battle_map.set_tutorial_container()
	battle_map.show_tutorial_text("
		Welcome to Fiber! In this tutorial you will learn the basics on how to play the game.
		\n\n(Click to continue)
	")
	pause_battlemap()
	next_phase = tutorial_phases.BATTLEMAP_EXPLANATION
	GameManager.turn_manager.turn_actions_enabled = true
	is_awaiting_tutorial_input = true


func _battlemap_explanation() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"This is the battlefield, consisting of 5 rows and 7 columns.\n\n(Click to continue)"
	)
	var arrow_position := Vector2(
		MapSettings.play_area_size.x - arrow_size.x * 1.5,
		MapSettings.total_screen.y / 2
	)
	_create_arrow(arrow_position, 180)
	pause_battlemap()
	next_phase = tutorial_phases.BLUE_RED_SPACES
	is_awaiting_tutorial_input = true


func _blue_red_spaces() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"You can play your units on the blue spaces.\n Your opponent can play their units on the 
		red spaces.\n\n(Click to continue)"
	)
	var arrow_position_x := MapSettings.get_column_start_x(5) + arrow_size.x * 2.5
	var blue_arrow_position := Vector2(arrow_position_x, MapSettings.card_in_hand_size.y * 3)
	var red_arrow_position := Vector2(
		arrow_position_x, MapSettings.total_screen.y - MapSettings.card_in_hand_size.y
	)
	_create_arrow(blue_arrow_position, 180)
	_create_arrow(red_arrow_position, 180)
	pause_battlemap()
	next_phase = tutorial_phases.HOVER_CARD
	is_awaiting_tutorial_input = true


func _hover_card() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"Try hovering a card in your hand.\n"
	)
	var arrow_position_y := MapSettings.play_area_end.y - arrow_size.y
	for c in GameManager.cards_in_hand[GameManager.player_id]:
		var arrow_position_x = c.position.x + arrow_size.x
		var arrow_position := Vector2(arrow_position_x, arrow_position_y)
		_create_arrow(arrow_position, 90)
	pause_battlemap()
	next_phase = tutorial_phases.PREVIEW_CARD


func _preview_card() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"When you hover cards in your hand or on the battlefield you'll see a preview in the upper 
		right corner.\n\n(Click to continue)"
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x - GameManager.zoom_preview.size.x / 4,
		GameManager.zoom_preview.position.y + GameManager.zoom_preview.size.y / 2
	)
	_create_arrow(arrow_position, 0)
	pause_battlemap()
	next_phase = tutorial_phases.CARD_COST
	is_awaiting_tutorial_input = true


func _card_cost() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"In the upper right corner of a card you'll find its costs. This Gorilla will cost 1 
		passion (red) resource to play.\n\n(Click to continue)"
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x + GameManager.zoom_preview.size.x,
		GameManager.zoom_preview.position.y + GameManager.zoom_preview.size.y
	)
	_create_arrow(arrow_position, 270)
	pause_battlemap()
	next_phase = tutorial_phases.CARD_MOVEMENT
	is_awaiting_tutorial_input = true


func _card_movement() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"In the lower left corner of a card you'll find its movement. This Gorilla will be able 
		to move 1 space each turn.\n\n(Click to continue)"
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x + GameManager.zoom_preview.size.x * 0.7,
		GameManager.zoom_preview.position.y + GameManager.zoom_preview.size.y * 1.9
	)
	_create_arrow(arrow_position, 180)
	pause_battlemap()
	next_phase = tutorial_phases.CARD_ATTACK_RANGE
	is_awaiting_tutorial_input = true


func _card_attack_range() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"After the movement value you will find the attack range. This Gorilla will be able 
		to attack units within a range of 1 space.\n\n(Click to continue)"
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x + GameManager.zoom_preview.size.x * 0.9,
		GameManager.zoom_preview.position.y + GameManager.zoom_preview.size.y * 1.9
	)
	_create_arrow(arrow_position, 180)
	pause_battlemap()
	next_phase = tutorial_phases.CARD_MAX_ATTACK
	is_awaiting_tutorial_input = true


func _card_max_and_min_attack() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"After the attack range you will find it's max attack (the sword) and it's min attack (the 
		dagger). \nWhenever this unit attacks, it damage will be a random number in between those two.
		\n\n(Click to continue)"
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x + GameManager.zoom_preview.size.x * 1.3,
		GameManager.zoom_preview.position.y + GameManager.zoom_preview.size.y * 1.9
	)
	_create_arrow(arrow_position, 180)
	pause_battlemap()
	next_phase = tutorial_phases.CARD_HEALTH
	is_awaiting_tutorial_input = true


func _card_health() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"After the max and min attack you'll find the card's health. When this reaches 0 the unit 
		will die.\n\n(Click to continue)"
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x + GameManager.zoom_preview.size.x * 1.5,
		GameManager.zoom_preview.position.y + GameManager.zoom_preview.size.y * 1.9
	)
	_create_arrow(arrow_position, 180)
	pause_battlemap()
	next_phase = tutorial_phases.CARD_SHIELD
	is_awaiting_tutorial_input = true


func _card_shield() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"The final number is the card's shield. Attack that hit a unit will deplete it's shield 
		first before subtracting from health.\n\n(Click to continue)"
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x + GameManager.zoom_preview.size.x * 1.7,
		GameManager.zoom_preview.position.y + GameManager.zoom_preview.size.y * 1.9
	)
	_create_arrow(arrow_position, 180)
	pause_battlemap()
	next_phase = tutorial_phases.RESOURCES
	is_awaiting_tutorial_input = true
	
	
func _resources() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"In the lower right corner of your screen you'll find your resources.\n
		Gold resources can be used for any faction (color) and refresh every turn.
		\n\n(Click to continue)"
	)
	GameManager.resources[GameManager.player_id].refresh(1)
	var arrow_position_y := (
		MapSettings.total_screen.y - MapSettings.resource_bar_size.y * 1.5 
		- MapSettings.end_turn_button_size.y
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x - arrow_size.x, arrow_position_y
	)
	_create_arrow(arrow_position, 0)
	pause_battlemap()
	next_phase = tutorial_phases.RESOURCE_REFRESH
	is_awaiting_tutorial_input = true


func _resource_refresh() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"The first player will start with 1 gold resource per turn. \nThe amount of gold resources
		players get will slowly increase over the course of the game. \nIn this container you'll
		find how much gold you're getting each turn and how many turns it will take to increase.
		\n\n(Click to continue)"
	)
	battle_map.update_gold_container_text(1, 1)
	var arrow_position_y: float = (
		battle_map.instruction_container.position.y 
		+ battle_map.instruction_container.size.y * 0.7
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x - arrow_size.x, arrow_position_y
	)
	_create_arrow(arrow_position, 0)
	pause_battlemap()
	next_phase = tutorial_phases.PLAY_CARD
	is_awaiting_tutorial_input = true


func _play_card() -> void:
	is_awaiting_tutorial_input = false
	battle_map.tutorial_container.position.x += battle_map.tutorial_container.size.x
	battle_map.show_tutorial_text(
		"You play cards by dragging them from your hand to the battlefield. Try dragging a Gorilla
		to one of your conquered (blue) spaces."
	)
	next_phase = tutorial_phases.FACTION_RESOURCES
	GameManager.turn_manager.turn_owner_id = GameManager.player_id
	unpause_battlemap()


func _faction_resources() -> void:
	is_awaiting_tutorial_input = false
	pause_battlemap()
	battle_map.show_tutorial_text(
		"Playing units will give you one resource of their faction. Unlike gold, this resource
		doesn't refresh and carries over turns.
		\n\n(Click to continue)"
	)
	var arrow_position_y := (
		MapSettings.total_screen.y - MapSettings.resource_bar_size.y * 1.5 
		- MapSettings.end_turn_button_size.y
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x - arrow_size.x, arrow_position_y
	)
	_create_arrow(arrow_position, 0)
	
	next_phase = tutorial_phases.MOVE_CARD
	is_awaiting_tutorial_input = true


func _move_card() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"You can select units to take actions by clicking them with the left mouse button.\n
		You can move units by clicking any space withing their movement range with the right mouse
		button.\n You will see an arrow that shows the selected movement. Click the right mouse
		button again to move."
	)
	unpause_battlemap()
	next_phase = tutorial_phases.ATTACK_CARD


func _attack_card() -> void:
	is_awaiting_tutorial_input = false
	await get_tree().create_timer(0.25).timeout
	var player_card: CardInPlay = GameManager.cards_in_play[GameManager.player_id][0]
	player_card.refresh()
	BattleSynchronizer.play_unit(
		CardDatabase.cards.GNOME_PROTECTOR, GameManager.p2_id, 
		player_card.current_play_space.column, player_card.current_play_space.row - 1
	)
	
	battle_map.show_tutorial_text(
		"You can attack cards within a range of 1 by selecting a unit and rightclicking an opponent
		unit. Try attacking your opponents unit."
	)
	next_phase = tutorial_phases.EXHAUST


func _exhaust() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"After you move or attack with a unit it will exhaust and you will be unable to use it
		until it refreshes. All your units refresh at the start of your turn.
		\n\n(Click to continue)"
	)
	await get_tree().create_timer(0.25).timeout
	var player_unit: CardInPlay = GameManager.cards_in_play[GameManager.player_id][0]
	var arrow_position := Vector2(
		player_unit.position.x + player_unit.size.x * 1.25,
		player_unit.position.y + player_unit.size.y * 1.25
	)
	_create_arrow(arrow_position, 180)
	pause_battlemap()
	next_phase = tutorial_phases.ATTACK_FURTHER
	is_awaiting_tutorial_input = true


func _attack_further() -> void:
	battle_map.tutorial_container.position.y -= battle_map.tutorial_container.size.y
	is_awaiting_tutorial_input = false
	if len(GameManager.cards_in_play[GameManager.p2_id]) != 0:
		for c in GameManager.cards_in_play[GameManager.p2_id]:
			c.call_deferred("destroy")
	
	var player_card: CardInPlay = GameManager.cards_in_play[GameManager.player_id][0]
	player_card.refresh()
	BattleSynchronizer.play_unit(
		CardDatabase.cards.GNOME_PROTECTOR, GameManager.p2_id, 
		player_card.current_play_space.column, player_card.current_play_space.row - 2)
	
	battle_map.show_tutorial_text(
		"You can attack cards within a range of 1 by selecting a unit and rightclicking an opponent
		unit. Try attacking your opponents unit."
	)
	next_phase = tutorial_phases.CONQUER_VICTORY_SPACES


func _conquer_victory_spaces() -> void:
	is_awaiting_tutorial_input = false
	await get_tree().create_timer(1).timeout
	if len(GameManager.cards_in_play[GameManager.p2_id]) != 0:
		for c in GameManager.cards_in_play[GameManager.p2_id]:
			c.call_deferred("destroy")
	var player_card: CardInPlay = GameManager.cards_in_play[GameManager.player_id][0]
	if !(player_card.column == 3 and player_card.row == 2):
		player_card.move_to_play_space(4, 3)
	
	battle_map.show_tutorial_text(
		"You can conquer victory spaces by right clicking on your unit and choosing \"conquer space
		\"."
	)
	for c in GameManager.cards_in_play[GameManager.player_id]:
		c.refresh()
	next_phase = tutorial_phases.PROGRESS_BAR


func _show_progress_bar() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"Whoever is the first to conquer 4 victory spaces will win the game. You can see each
		player's progress by checking the progress bars on the right side of the battlefield.
		\n\n(Click to continue)"
	)
	var arrow_position := Vector2(
		MapSettings.total_screen.x - arrow_size.x,
		MapSettings.total_screen.y / 2
	)
	_create_arrow(arrow_position, 180)
	pause_battlemap()
	next_phase = tutorial_phases.USE_ABILITIES
	is_awaiting_tutorial_input = true


func _use_abilities() -> void:
	is_awaiting_tutorial_input = false
	battle_map.show_tutorial_text(
		"Some cards, like this Wizard Scout, have abilities. You can use them by right clicking 
		on the unit and selecting the ability. Try swapping your Wizard Scout with your Gorilla."
	)
	BattleSynchronizer.play_unit(
		CardDatabase.cards.WIZARD_SCOUT, GameManager.player_id, 
		2, 1)
	
	var wizard_position: Vector2 = GameManager.ps_column_row[2][1].position
	var arrow_position := Vector2(
		wizard_position.x + MapSettings.card_in_play_size.x * 2,
		wizard_position.y + MapSettings.card_in_play_size.y * 0.75
	)
	_create_arrow(arrow_position, 180)
	unpause_battlemap()
	next_phase = tutorial_phases.SPELLS


func _spells() -> void:
	is_awaiting_tutorial_input = false
	for c in GameManager.cards_in_hand[GameManager.player_id]:
		c.discard()
	GameManager.decks[GameManager.player_id].create_hand_card(CardDatabase.cards.ATTACK_COMMAND)
	GameManager.zoom_preview.preview_card_index(CardDatabase.cards.ATTACK_COMMAND, true)
	battle_map.show_tutorial_text(
		"Some cards are spells. You play them by dragging them onto the battlefield, but after their
		effect has been used they will disappear. If they have a range, like Attack Command, they
		need to be used within that range of one of your units.
		\n\n(Click to continue)"
	)
	var arrow_position := Vector2(
		GameManager.zoom_preview.position.x + GameManager.zoom_preview.size.x * 0.4,
		GameManager.zoom_preview.position.y + GameManager.zoom_preview.size.y
	)
	_create_arrow(arrow_position, 0)
	
	pause_battlemap()
	next_phase = tutorial_phases.USE_ATTACK_COMMAND
	is_awaiting_tutorial_input = true


func _use_attack_command() -> void:
	is_awaiting_tutorial_input = false
	for c in GameManager.cards_in_play[GameManager.player_id]:
		c.call_deferred("destroy")
	for c in GameManager.cards_in_play[GameManager.p2_id]:
		c.call_deferred("destroy")
	
	BattleSynchronizer.play_unit(
		CardDatabase.cards.GORILLA, GameManager.player_id, 
		3, 3
	)
	BattleSynchronizer.play_unit(
		CardDatabase.cards.WIZARD_SCOUT, GameManager.p2_id, 
		3, 1
	)
	
	battle_map.show_tutorial_text(
		"Try dragging Attack command from your hand to the battlefield. Then target the Gorilla.
		Next target the Wizard Scout."
	)
	
	unpause_battlemap()
	next_phase = tutorial_phases.END_TURN


func _end_turn() -> void:
	is_awaiting_tutorial_input = false
	GameManager.battle_map.end_turn_button_container.show()
	battle_map.show_tutorial_text(
		"You end your turn by clicking this button in the lower right corner. Click it to finish
		this tutorial."
	)
	var arrow_position := Vector2(
		GameManager.battle_map.end_turn_button_container.position.x - arrow_size.x * 2,
		GameManager.battle_map.end_turn_button_container.position.y
	)
	_create_arrow(arrow_position, 0)
	
	pause_battlemap()
	next_phase = tutorial_phases.FINISH_TUTORIAL
	is_awaiting_tutorial_input = true


func _finish_tutorial() -> void:
	TransitionScene.transition_to_overworld_scene(
		OverworldManager.saved_area_id, OverworldManager.saved_player_position
	)


func pause_battlemap() -> void:
	for c in battle_map.get_children():
		c.process_mode = PROCESS_MODE_DISABLED
	GameManager.is_ready_to_play = false


func unpause_battlemap() -> void:
	for c in battle_map.get_children():
		c.process_mode = PROCESS_MODE_INHERIT
	GameManager.is_ready_to_play = true


func _create_arrow(arrow_position: Vector2, arrow_rotation_degrees: int) -> void:
	var arrow = play_space_arrow_scene.instantiate()
	arrow.position.x = arrow_position.x
	arrow.position.y = arrow_position.y
	arrow.scale *= arrow_size / arrow.size
	arrow.rotation_degrees = arrow_rotation_degrees
	current_arrows.append(arrow)
	battle_map.add_child(arrow)


func _cleanup_tutorial() -> void:
	is_awaiting_tutorial_input = false
	next_phase = tutorial_phases.INSTRUCTION_START
	current_arrows = []


func continue_tutorial() -> void:
	for a in current_arrows:
		a.queue_free()
	current_arrows = []
	unpause_battlemap()
	match next_phase:
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
		tutorial_phases.CARD_MOVEMENT:
			_card_movement()
		tutorial_phases.CARD_ATTACK_RANGE:
			_card_attack_range()
		tutorial_phases.CARD_MAX_ATTACK:
			_card_max_and_min_attack()
		tutorial_phases.CARD_HEALTH:
			_card_health()
		tutorial_phases.CARD_SHIELD:
			_card_shield()
		tutorial_phases.RESOURCES:
			_resources()
		tutorial_phases.RESOURCE_REFRESH:
			_resource_refresh()
		tutorial_phases.PLAY_CARD:
			_play_card()
		tutorial_phases.FACTION_RESOURCES:
			_faction_resources()
		tutorial_phases.MOVE_CARD:
			_move_card()
		tutorial_phases.ATTACK_CARD:
			_attack_card()
		tutorial_phases.EXHAUST:
			_exhaust()
		tutorial_phases.ATTACK_FURTHER:
			_attack_further()
		tutorial_phases.CONQUER_VICTORY_SPACES:
			_conquer_victory_spaces()
		tutorial_phases.PROGRESS_BAR:
			_show_progress_bar()
		tutorial_phases.USE_ABILITIES:
			_use_abilities()
		tutorial_phases.SPELLS:
			_spells()
		tutorial_phases.USE_ATTACK_COMMAND:
			_use_attack_command()
		tutorial_phases.END_TURN:
			_end_turn()
		tutorial_phases.FINISH_TUTORIAL:
			_finish_tutorial()
	
