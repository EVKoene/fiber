extends Node


"""Faction Colors"""
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


"""Space Border colors"""
var base_space_color = Color("3b3b3bdc")
var resource_space_color = Color("3b773bdc")
var start_space_color = Color("ffffffdc")
var p1_color = Color("3b3be7dc")
var p2_color = Color("f70800")
