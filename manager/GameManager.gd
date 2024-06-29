extends Node

var players := {}
var p1_id: int
var p2_id: int
var p1: Player
var p2: Player

var battle_map
var resource_spaces := []
var turn_manager: TurnManager

# is_player_1 should always be the same as is_server, because the server will start the game and be
# made player 1. For purposes of matching player_id for example I think it's cleaner to have them
# be seperate values.
var is_player_1 := false
var player_id: int  # The player's own id
var is_server := false

var ps_column_row := {}
var zoom_preview: ZoomPreview
var resource_bar_p1: ResourceBar
var resource_bar_p2: ResourceBar
var progress_bars := {}
var resources := {}

var starting_draw: int = 3

# cards_in_hand and cards_in_play contain the two player ids as keys with an array containing all 
# the the current card nodes beloning to them.
var cards_in_hand := {}
var cards_in_play := {}


func player_from_id(p_id: int) -> Player:
	var p: Player
	match p_id:
		p1_id:
			p = p1
		p2_id:
			p = p2
		_:
			assert(false, str("Unknow player id: ", p_id))
	
	return p


func opposing_player_id(p_id: int) -> int:
	if p_id == p1_id:
		return p2_id
	else:
		return p1_id


@rpc("call_local")
func remove_card_from_hand(p_id: int, hand_index: int) -> void:
	GameManager.cards_in_hand[p_id].remove_at(hand_index)
