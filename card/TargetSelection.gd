extends Node

signal target_selection_finished
signal space_selection_finished


enum target_restrictions {ANY_SPACE, OWN_UNITS, OPPONENT_UNITS, ANY_UNITS}


var making_selection := false
var selected_card: CardInPlay
var selected_targets := []
var number_of_targets_to_select := 0
var self_allowed := false
var selecting_unit: CardInPlay
var players_to_select_targets_from := []
var target_play_space_options := []
var card_action_menu: CardActionMenu

var current_path: PlaySpacePath
var play_space_arrows := []

var card_selected_for_movement: CardInPlay
var play_space_selected_for_movement: PlaySpace
var card_to_be_attacked: CardInPlay

var selected_spaces := []
var number_of_spaces_to_select := 0
var selecting_spaces := false

var can_drag_to_select := false
var dragging_to_select := false
var drag_start := Vector2.ZERO
var drag_end := Vector2.ZERO
var drag_selection_range := 0
var select_rect := RectangleShape2D.new()  # Collision shape for drag box.
var n_lowest_axis_to_select := 0
var n_highest_axis_to_select := 0
var selected_columns := []
var selected_rows := []

var discarding := false


func select_targets(
	n_targets: int, _target_restrictions: int, _selecting_unit: CardInPlay, _self_allowed: bool, 
	range_from_unit: int, ignore_obstacles := true
) -> void:
	#NOTE: We disable turn actions here but don't enable them in the same function. That means
	# that any function that will call this function will have to enable turn actions again
	GameManager.turn_manager.set_turn_actions_enabled(false)
	
	making_selection = true
	number_of_targets_to_select = n_targets
	self_allowed = _self_allowed
	selecting_unit = _selecting_unit
	
	match _target_restrictions:
		target_restrictions.ANY_UNITS:
			players_to_select_targets_from = [GameManager.p1_id, GameManager.p2_id]
		target_restrictions.OWN_UNITS:
			players_to_select_targets_from = [GameManager.player_id]
		target_restrictions.OPPONENT_UNITS:
			players_to_select_targets_from = [
				GameManager.opposing_player_id(GameManager.player_id)
			]
	
	if range_from_unit == -1:
		target_play_space_options = GameManager.play_spaces
	else:
		target_play_space_options = selecting_unit.spaces_in_range(
			range_from_unit, ignore_obstacles
		)


func select_play_spaces(number_of_spaces: int, play_space_options: Array) -> void:
	#NOTE: We disable turn actions here but don't enable them in the same function. That means
	# that any function that will call this function will have to enable turn actions again
	GameManager.turn_manager.set_turn_actions_enabled(false)
	
	making_selection = true
	number_of_spaces_to_select = number_of_spaces
	target_play_space_options = play_space_options
	selecting_spaces = true


@rpc("any_peer", "call_local")
func select_card_to_discard() -> void:
	if len(GameManager.cards_in_hand[GameManager.player_id]) == 0:
		return
	
	GameManager.turn_manager.set_turn_actions_enabled(false)
	
	making_selection = true
	discarding = true
	Events.show_instructions.emit("Pick a card to discard")
	await Events.card_discarded
	end_selecting()


@rpc("any_peer", "call_local")
func end_selecting() -> void:
	GameManager.zoom_preview.reset_zoom_preview()
	
	if making_selection:
		target_selection_finished.emit()
		making_selection = false
	number_of_targets_to_select = 0
	self_allowed = false
	selecting_unit = null
	players_to_select_targets_from = []
	target_play_space_options = []
	current_path = null
	card_selected_for_movement = null
	play_space_selected_for_movement = null
	card_to_be_attacked = null
	discarding = false
	clear_paths()
	clear_arrows()
	clear_selections()
	clear_card_action_menu()
	Events.hide_instructions.emit()


func clear_selections() -> void:
	card_selected_for_movement = null
	selected_card = null
	selected_targets = []
	selected_columns = []
	selected_rows = []
	selected_spaces = []
	selecting_spaces = false
	number_of_spaces_to_select = 0
	if GameManager.is_single_player:
		CardManipulation.set_all_borders_to_faction()
		BattleAnimation.unhighlight_all_spaces()
	
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			CardManipulation.set_all_borders_to_faction.rpc_id(p_id)
			BattleAnimation.unhighlight_all_spaces.rpc_id(p_id)


func clear_paths() -> void:
	if current_path:
		current_path.queue_free()
		current_path = null
	clear_arrows()


func clear_arrows() -> void:
	for a in play_space_arrows:
		a.queue_free()
	
	play_space_arrows = []


func clear_card_action_menu() -> void:
	if card_action_menu:
		card_action_menu.queue_free()
		card_action_menu = null


func end_drag_to_select() -> void:
	can_drag_to_select = false
	dragging_to_select = false
	drag_start = Vector2.ZERO
	drag_end = Vector2.ZERO
	drag_selection_range = 0
	select_rect = RectangleShape2D.new()  # Collision shape for drag box.
	n_lowest_axis_to_select = 0
	n_highest_axis_to_select = 0
	selected_columns = []
	selected_rows = []
