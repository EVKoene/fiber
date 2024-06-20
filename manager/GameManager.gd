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

var play_spaces_by_position := {}
var play_spaces := []

var starting_draw: int = 3
