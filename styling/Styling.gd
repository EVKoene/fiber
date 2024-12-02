extends Node


"""Faction Colors"""
var faction_colors := {
	[Collections.factions.PASSION]: Color("932011"),
	[Collections.factions.PASSION, Collections.factions.IMAGINATION]: Color("e74c22"),
	[Collections.factions.PASSION, Collections.factions.GROWTH]: Color("bd9517"),
	[Collections.factions.PASSION, Collections.factions.LOGIC]: Color("c66d65"),
	[Collections.factions.IMAGINATION]: Color("7701d3"),
	[Collections.factions.IMAGINATION, Collections.factions.GROWTH]: Color("5a9696"),
	[Collections.factions.IMAGINATION, Collections.factions.LOGIC]: Color("f8baf2"),
	[Collections.factions.GROWTH]: Color("1b7620"),
	[Collections.factions.GROWTH, Collections.factions.LOGIC]: Color("26bb5c"),
	[Collections.factions.LOGIC]: Color("5d5d68")
}
var gold_color := Color("6e6914")
var multifaction_color := Color("e74c22")


"""Space Border colors"""
var base_space_color = Color("3b3b3bdc")
var victory_space_color = Color("63ac23")
var start_space_color = Color("ffffffdc")
var p1_color = Color("3b3be7dc")
var p2_color = Color("f70800")
var p1_conquered_color = Color("63acff")
var p2_conquered_color = Color("ff5847")
