extends Panel

class_name Resources


var gold := 1
var animal := 1
var magic := 1
var nature := 1
var robot := 1
var resources_owner_id: int


func _ready():
	_update_resource_dependencies()


func _init(_resources_owner_id: int):
	resources_owner_id = _resources_owner_id


func can_pay_costs(costs: Costs) -> bool:
	if gold_needed(costs) <= gold:
		return true
	else:
		return false


func pay_costs(costs: Costs) -> void:
	gold -= gold_needed(costs)
	for faction in Collections.all_factions:
		if get_resources()[faction] > costs.get_costs()[faction]:
			spend_resource(faction, costs.get_costs()[faction])
		else:
			spend_resource(faction, get_resources()[faction])


func add_resource(faction: int, amount: int) -> void:
	match faction:
		Collections.factions.ANIMAL:
			animal += amount
		Collections.factions.MAGIC:
			magic += amount
		Collections.factions.NATURE:
			nature += amount
		Collections.factions.ROBOT:
			robot += amount
	
	_update_resource_dependencies()


func spend_resource(faction: Collections.factions, amount: int) -> void:
	match faction:
		Collections.factions.ANIMAL:
			animal -= amount
		Collections.factions.MAGIC:
			magic -= amount
		Collections.factions.NATURE:
			nature -= amount
		Collections.factions.ROBOT:
			robot -= amount
	
	_update_resource_dependencies()


func reset() -> void:
	animal = 0
	magic = 0
	nature = 0
	robot = 0
	_update_resource_dependencies()
	if GameManager.turn_count == 2:
		gold = 2
	else:
		gold = 1


func gold_needed(costs: Costs) -> int:
	var deficiency: int = 0
	for faction in Collections.faction_names:
		var resources_minus_costs: int = get_resources()[faction] - costs.get_costs()[faction]
		if resources_minus_costs < 0:
			deficiency -= resources_minus_costs
			
	return deficiency


func get_resources() -> Dictionary:
	return {
		Collections.factions.ANIMAL: animal,
		Collections.factions.MAGIC: magic,
		Collections.factions.NATURE: nature,
		Collections.factions.ROBOT: robot,
	}


func _update_resource_dependencies() -> void:
	_update_can_pay_for_cards_in_hand()
	_set_resources_labels()


func _update_can_pay_for_cards_in_hand() -> void:
	for c in GameManager.cards_in_hand[resources_owner_id]:
		c.can_pay_costs = can_pay_costs(c.costs)


func _set_resources_labels() -> void:
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		SmoothVisuals.set_resource_labels.rpc_id(
			p_id, resources_owner_id, gold, animal, magic, nature, robot
		)
