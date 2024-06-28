extends Node

enum target_restrictions {ANY_SPACE, OWN_UNITS, OPPONENT_UNITS, ANY_UNITS, SAME_FOR_ALL_TARGETS}


var making_selection := false
var selected_cards := []
var number_of_targets_to_select := 0

var current_path: PlaySpacePath
var play_space_arrows := []

var card_selected_for_movement: CardInPlay
var play_space_selected_for_movement: PlaySpace
var card_to_be_attacked: CardInPlay


func end_selecting() -> void:
	GameManager.turn_manager.turn_actions_enabled = true
	making_selection = false
	number_of_targets_to_select = 0
	clear_paths()
	clear_arrows()
	clear_selections()


func clear_selections() -> void:
	card_selected_for_movement = null
	selected_cards = []
	for c in GameManager.cards_in_play[GameManager.player_id]:
		c.set_border_to_faction()


func clear_paths() -> void:
	if current_path:
		current_path.queue_free()
		current_path = null


func clear_arrows() -> void:
	for a in play_space_arrows:
		a.queue_free()
	
	play_space_arrows = []
