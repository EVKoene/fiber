extends Node


"""Faction Colors"""
var faction_colors := {
	[Collections.fibers.PASSION]: Color("932011"),
	[Collections.fibers.PASSION, Collections.fibers.IMAGINATION]: Color("e74c22"),
	[Collections.fibers.PASSION, Collections.fibers.GROWTH]: Color("bd9517"),
	[Collections.fibers.PASSION, Collections.fibers.LOGIC]: Color("c66d65"),
	[Collections.fibers.IMAGINATION]: Color("7701d3"),
	[Collections.fibers.IMAGINATION, Collections.fibers.GROWTH]: Color("5a9696"),
	[Collections.fibers.IMAGINATION, Collections.fibers.LOGIC]: Color("f8baf2"),
	[Collections.fibers.GROWTH]: Color("1b7620"),
	[Collections.fibers.GROWTH, Collections.fibers.LOGIC]: Color("26bb5c"),
	[Collections.fibers.LOGIC]: Color("5d5d68")
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
