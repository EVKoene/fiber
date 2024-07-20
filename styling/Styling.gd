extends Node


"""Colors"""
var faction_colors := {
	[Collections.factions.ANIMAL]: Color("932011"),
	[Collections.factions.ANIMAL, Collections.factions.MAGIC]: Color("e74c22"),
	[Collections.factions.ANIMAL, Collections.factions.NATURE]: Color("bd9517"),
	[Collections.factions.ANIMAL, Collections.factions.ROBOT]: Color("c66d65"),
	[Collections.factions.MAGIC]: Color("7701d3"),
	[Collections.factions.MAGIC, Collections.factions.NATURE]: Color("5a9696"),
	[Collections.factions.MAGIC, Collections.factions.ROBOT]: Color("f8baf2"),
	[Collections.factions.NATURE]: Color("1b7620"),
	[Collections.factions.NATURE, Collections.factions.ROBOT]: Color("26bb5c"),
	[Collections.factions.ROBOT]: Color("5d5d68")
}
var gold_color := Color("6e6914")
var multifaction_color := Color("e74c22")


"""Space Borders"""
var base_space_border = load("res://styling/play_space_borders/BaseSpace.tres")
var draw_card_space_border = load("res://styling/play_space_borders/DrawCardSpace.tres")
var p2_start_space_border = load("res://styling/play_space_borders/OpponentStartSpace.tres")
var p1_start_space_border = load("res://styling/play_space_borders/PlayerStartSpace.tres")
var resource_space_border = load("res://styling/play_space_borders/ResourceSpace.tres")
