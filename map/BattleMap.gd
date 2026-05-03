extends Node2D

class_name BattleMap

signal text_dismissed

@onready var card_pick_scene: PackedScene = preload("res://card/CardPickScreen.tscn")
@onready var card_resolve_scene := load("res://card/card_classes/CardResolve.tscn")

var setup: BattleMapSetup
var ui: BattleMapUI
var text_handler: BattleMapText
var input_handler: BattleMapInputHandler

var awaiting_input := false
var is_tutorial := false


func _ready():
	setup = BattleMapSetup.new(self)
	ui = BattleMapUI.new(self)
	text_handler = BattleMapText.new(self)
	input_handler = BattleMapInputHandler.new(self)

	if GameManager.is_single_player:
		_create_ai_player()
	#$AudioStreamPlayer2D.play()
	GameManager.battle_map = self

	_setup_components()
	_create_progress_bars()
	# Because create_starting_territory() calls rpc funcs we wait a second for both players to setup
	await get_tree().create_timer(1).timeout
	setup.create_starting_territory()

	if GameManager.is_single_player:
		GameManager.setup_game()
	elif GameManager.is_player_1:
		# To make sure the cards and card orders are always the same for both players, we only create
		# the decks on the server
		GameManager.setup_game.rpc_id(1)

	Events.show_instructions.connect(show_instructions)
	Events.hide_instructions.connect(hide_instructions)


func _setup_components() -> void:
	setup.create_battle_map()
	ui.set_zoom_preview_position_and_size()
	ui.set_end_turn_button()
	ui.set_finish_button()
	ui.set_resolve_spell_button()
	ui.set_resource_bars_position_and_size()
	ui.set_text_containers()


func _create_ai_player() -> void:
	GameManager.ai_player = AIPlayer.new()
	GameManager.ai_player_id = GameManager.p2_id
	GameManager.ai_player.player_id = GameManager.p2_id
	GameManager.ai_player.ai_turn_manager = AITurnManager.new()


func _create_progress_bars() -> void:
	setup.create_progress_bars()


@rpc("any_peer", "call_local")
func pick_card_option(card_indices: Array) -> void:
	var card_pick_screen := card_pick_scene.instantiate()
	card_pick_screen.card_indices = card_indices
	card_pick_screen.size = MapSettings.total_screen
	card_pick_screen.z_index += 50
	call_deferred("add_child", card_pick_screen)


@rpc("any_peer", "call_local")
func create_card_resolve(card_owner_id: int, cih_index: int, column: int, row: int) -> void:
	GameManager.turn_manager.set_turn_actions_enabled(false)

	var card_resolve = card_resolve_scene.instantiate()
	var card_in_hand = GameManager.cards_in_hand[card_owner_id][cih_index]
	card_resolve.card_index = card_in_hand.card_index
	card_resolve.column = column
	card_resolve.row = row
	card_resolve.card_owner_id = card_in_hand.card_owner_id
	card_resolve.card_in_hand_index = cih_index
	card_resolve.size = MapSettings.total_screen
	add_child(card_resolve)


func show_text(text_to_show: String) -> void:
	text_handler.show_text(text_to_show)


func hide_text() -> void:
	text_handler.hide_text()


func show_instructions(instruction_text: String) -> void:
	ui.show_instructions(instruction_text)


func hide_instructions() -> void:
	ui.hide_instructions()


func show_finish_button() -> void:
	ui.show_finish_button()


func hide_finish_button() -> void:
	ui.hide_finish_button()


func show_resolve_spell_button() -> void:
	ui.show_resolve_spell_button()


func update_gold_container_text(gold_gained: int, turns_until_increase: int) -> void:
	ui.update_gold_container_text(gold_gained, turns_until_increase)


func set_tutorial_container() -> void:
	text_handler.set_tutorial_container()


func show_tutorial_text(tutorial_text: String) -> void:
	text_handler.show_tutorial_text(tutorial_text)


func hide_tutorial_text() -> void:
	text_handler.hide_tutorial_text()


func _input(event):
	input_handler.handle_input(event)


func _unhandled_input(event):
	input_handler.handle_unhandled_input(event)


func _draw():
	input_handler.draw()


func _on_end_turn_button_pressed():
	if Tutorial.next_phase == Tutorial.tutorial_phases.FINISH_TUTORIAL:
		Tutorial.continue_tutorial()
	if !GameManager.turn_manager.turn_actions_enabled:
		return

	GameManager.turn_manager.end_turn.rpc_id(1, GameManager.player_id)


func _on_resolve_spell_button_pressed():
	if GameManager.is_single_player:
		BattleSynchronizer.resolve_spell_agreed()
	if !GameManager.is_single_player:
		BattleSynchronizer.resolve_spell_agreed.rpc_id(
			GameManager.opposing_player_id(GameManager.player_id)
		)
	$ResolveSpellButton.hide()


func _on_finish_button_pressed() -> void:
	Events.finish_button_pressed.emit()
	TargetSelection.space_selection_finished.emit()
	TargetSelection.target_selection_finished.emit()
	ui.hide_finish_button()
