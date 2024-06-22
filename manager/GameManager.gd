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

var starting_draw: int = 3

var cards_in_hand := {}


@rpc("call_local")
func remove_card_from_hand(player_id: int, hand_index: int) -> void:
	GameManager.cards_in_hand[player_id].remove_at(hand_index)
