extends CardInPlay


class_name FactoryWorker


func _init():
	abilities = [{
		"FuncName": "add_r",
		"FuncText": "Add 1 R",
		"AbilityCosts": Costs.new(0, 0, 0, 0)
	}]


func add_r() -> void:
	GameManager.resources[card_owner_id].add_resource(Collections.factions.LOGIC, 1)
	exhaust()
