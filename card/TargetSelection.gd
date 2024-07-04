extends Node

signal target_selection_finished


enum target_restrictions {ANY_SPACE, OWN_UNITS, OPPONENT_UNITS, ANY_UNITS}


var making_selection := false
var selected_card: CardInPlay
var selected_targets := []
var number_of_targets_to_select := 0
var self_allowed := false
var selecting_unit: CardInPlay
var players_to_select_targets_from := []
var target_play_space_options := []

var current_path: PlaySpacePath
var play_space_arrows := []

var card_selected_for_movement: CardInPlay
var play_space_selected_for_movement: PlaySpace
var card_to_be_attacked: CardInPlay


func select_targets(
	n_targets: int, _target_restrictions: int, _selecting_unit: CardInPlay, _self_allowed: bool, 
	range_from_unit: int, ignore_obstacles: bool
) -> void:
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
		target_play_space_options = MapSettings.play_spaces
	else:
		target_play_space_options = selecting_unit.spaces_in_range(
			range_from_unit, ignore_obstacles
		)


@rpc("any_peer", "call_local")
func end_selecting() -> void:
	GameManager.turn_manager.turn_actions_enabled = true
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
	clear_paths()
	clear_arrows()
	clear_selections()
	GameManager.zoom_preview.reset_zoom_preview()


func clear_selections() -> void:
	card_selected_for_movement = null
	selected_card = null
	selected_targets = []
	for p in GameManager.player_ids:
		for c in GameManager.cards_in_play[p]:
			c.set_border_to_faction()


func clear_paths() -> void:
	if current_path:
		current_path.queue_free()
		current_path = null


func clear_arrows() -> void:
	for a in play_space_arrows:
		a.queue_free()
	
	play_space_arrows = []

