extends Node

var version := "0.0.1"
var testing := true
var p1_id: int
var p2_id: int
var players := {}

var is_single_player := false
var battle_map
var resource_spaces := []
var turn_manager: TurnManager

# is_player_1 should always be the same as is_server, because the server will start the game and be
# made player 1. For purposes of matching player_id for example I think it's cleaner to have them
# be seperate values.
var is_player_1 := false
var player_id: int  # The player's own id
var is_server := false

var play_spaces := []
var ps_column_row := {}
var zoom_preview: ZoomPreview
var resource_bars := {}
var progress_bars := {}
var resources := {}
# Decks should only be visible to the server
var decks := {}

var starting_draw: int = 1

# cards_in_hand and cards_in_play contain the two player ids as keys with an array containing all 
# the the current card nodes beloning to them. They use the card_in_play_index (cip_index) and
# hand_index.
var cards_in_hand := {}
var cards_in_play := {}

var territories := []

var ai_player: AIPlayer
var ai_player_id: int


func call_triggered_funcs(trigger: int, triggering_card: CardInPlay) -> void:
	for p_id in [p1_id, p2_id]:
		for card in cards_in_play[p_id]:
			await card.call_triggered_funcs(trigger, triggering_card)


func opposing_player_id(p_id: int) -> int:
	if p_id == p1_id:
		return p2_id
	else:
		return p1_id
