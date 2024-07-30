extends Panel

class_name Resources


var gold := 0
var animal := 0
var magic := 0
var nature := 0
var robot := 0
var resources_owner_id: int


func _init(_resources_owner_id: int):
	resources_owner_id = _resources_owner_id


func _ready():
	_update_resources()


func can_pay_costs(costs: Costs) -> bool:
	if GameManager.testing:
		return true
	if gold_needed(costs) <= gold:
		return true
	else:
		return false


func pay_costs(costs: Costs) -> void:
	if GameManager.testing:
		return
	
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
	
	_update_resources()


func spend_resource(faction: Collections.factions, value: int) -> void:
	match faction:
		Collections.factions.ANIMAL:
			animal -= value
		Collections.factions.MAGIC:
			magic -= value
		Collections.factions.NATURE:
			nature -= value
		Collections.factions.ROBOT:
			robot -= value
	
	_update_resources()


@rpc("call_local", "any_peer")
func refresh(turn_count: int) -> void:
	animal = 0
	magic = 0
	nature = 0
	robot = 0
	if turn_count >= 2:
		gold = 2
	else:
		gold = 1
	add_resources_from_spaces()
	_update_resources()


func gold_needed(costs: Costs) -> int:
	var deficiency: int = 0
	for faction in Collections.faction_names:
		var resources_minus_costs: int = get_resources()[faction] - costs.get_costs()[faction]
		if resources_minus_costs < 0:
			deficiency -= resources_minus_costs
			
	return deficiency


func add_resources_from_spaces() -> void:
	for ps in GameManager.resource_spaces:
		if ps.conquered_by == resources_owner_id:
			gold += 2


func get_resources() -> Dictionary:
	return {
		Collections.factions.ANIMAL: animal,
		Collections.factions.MAGIC: magic,
		Collections.factions.NATURE: nature,
		Collections.factions.ROBOT: robot,
	}


func _update_resources() -> void:
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		MultiPlayerManager.set_resources.rpc_id(
			p_id, resources_owner_id, gold, animal, magic, nature, robot
		)
