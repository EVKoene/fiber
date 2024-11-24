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
	
	var deficiency: int = 0
	
	for faction in Collections.faction_names:
		var resources_minus_costs: int = get_resources()[faction] - costs.get_costs()[faction]
		if resources_minus_costs < 0:
			deficiency -= resources_minus_costs
			
	if deficiency > gold:
		return false
	
	return true


func pay_costs(costs: Costs) -> void:
	if GameManager.testing:
		return
	
	if gold >= costs.total():
		gold -= costs.total()
		return
	
	for f in [
		Collections.factions.ANIMAL, Collections.factions.MAGIC, Collections.factions.NATURE, 
		Collections.factions.ROBOT
	]:
		var cost: int = costs.get_costs()[f]
		if cost == 0:
			continue
		if gold >= cost:
			gold -= cost
		else:
			cost -= gold
			gold = 0
			spend_resource(f, cost)


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


func add_gold(amount: int) -> void:
	gold += amount
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


@rpc("call_remote")
func refresh(gold_gained: int) -> void:
	gold = gold_gained
	
	_update_resources()


func get_resources() -> Dictionary:
	return {
		Collections.factions.ANIMAL: animal,
		Collections.factions.MAGIC: magic,
		Collections.factions.NATURE: nature,
		Collections.factions.ROBOT: robot,
	}


func _update_resources() -> void:
	if GameManager.is_single_player:
		GameManager.resource_bars[resources_owner_id].set_resources_labels(
			gold, animal, magic, nature, robot
		)
	else:
		for p_id in GameManager.players:
			BattleSynchronizer.set_resources.rpc_id(
				p_id, resources_owner_id, gold, animal, magic, nature, robot
			)
