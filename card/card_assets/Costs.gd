extends Panel

class_name Costs

var passion: int
var imagination: int
var growth: int
var logic: int
var card


func _init(_passion: int, _imagination: int, _growth: int, _logic: int, _card: Card = null):
	passion = _passion
	imagination = _imagination
	growth = _growth
	logic = _logic
	card = _card


func total() -> int:
	return passion + imagination + growth + logic


func get_costs() -> Dictionary:
	return {
		Collections.fibers.PASSION: passion,
		Collections.fibers.IMAGINATION: imagination,
		Collections.fibers.GROWTH: growth,
		Collections.fibers.LOGIC: logic,
	}


func change_cost(fiber: int, value: int) -> void:
	match fiber:
		Collections.fibers.PASSION:
			passion += value
		Collections.fibers.IMAGINATION:
			imagination += value
		Collections.fibers.GROWTH:
			growth += value
		Collections.LOGIC:
			logic += value

	card.set_card_properties()
