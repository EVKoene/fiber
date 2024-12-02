extends Panel

class_name Costs

var passion: int
var imagionation: int
var growth: int
var logic: int



func _init(_passion, _imagionation, _growth, _logic):
	passion = _passion
	imagionation = _imagionation
	growth = _growth
	logic = _logic


func total() -> int:
	return passion + imagionation + growth + logic


func get_costs() -> Dictionary:
	return {
		Collections.factions.PASSION: passion,
		Collections.factions.IMAGINATION: imagionation,
		Collections.factions.GROWTH: growth,
		Collections.factions.LOGIC: logic,
	}
