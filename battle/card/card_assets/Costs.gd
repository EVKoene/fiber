extends Panel

class_name Costs

var passion: int
var imagination: int
var growth: int
var logic: int



func _init(_passion, _imagination, _growth, _logic):
	passion = _passion
	imagination = _imagination
	growth = _growth
	logic = _logic


func total() -> int:
	return passion + imagination + growth + logic


func get_costs() -> Dictionary:
	return {
		Collections.factions.PASSION: passion,
		Collections.factions.IMAGINATION: imagination,
		Collections.factions.GROWTH: growth,
		Collections.factions.LOGIC: logic,
	}
