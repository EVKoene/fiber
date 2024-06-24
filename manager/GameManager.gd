extends Node

var players := {}
var p1_id: int
var p2_id: int
var p1: Player
var p2: Player
var battle_map
var resource_spaces := []
var is_player_1 := false
var player_id: int
var is_server := false

var ps_column_row := {}
var play_spaces := []
var zoom_preview: ZoomPreview
var resource_bar_p1: ResourceBar
var resource_bar_p2: ResourceBar
var resources := {}

var starting_draw: int = 3

# cards_in_hand contains the two player ids as keys with an array containing all the the current 
# CardInHand nodes beloning to them.
var cards_in_hand := {}
var turn_count := 0


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


@rpc("call_local")
func remove_card_from_hand(p_id: int, hand_index: int) -> void:
	GameManager.cards_in_hand[p_id].remove_at(hand_index)
