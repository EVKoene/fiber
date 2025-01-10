extends CardInPlay


class_name FactoryWorker


func _init():
	abilities = [{
		"FuncName": "add_r",
		"FuncText": "Add 1 R",
		"AbilityCosts": Costs.new(0, 0, 0, 0)
	}]


func add_r() -> void:
	GameManager.resources[card_owner_id].add_resource(Collections.fibers.LOGIC, 1)
	exhaust()


func resolve_ability_for_ai() -> void:
	add_r()


func is_ability_to_use_now() -> bool:
	if len(GameManager.cards_in_hand[card_owner_id]) >= 1:
		return true
	
	return false
