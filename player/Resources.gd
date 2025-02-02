extends Panel

class_name Resources

var gold := 0
var passion := 0
var imagination := 0
var growth := 0
var logic := 0
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
		_update_resources()
		return

	for f in [
		Collections.fibers.PASSION,
		Collections.fibers.IMAGINATION,
		Collections.fibers.GROWTH,
		Collections.fibers.LOGIC
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
		Collections.fibers.PASSION:
			passion += amount
		Collections.fibers.IMAGINATION:
			imagination += amount
		Collections.fibers.GROWTH:
			growth += amount
		Collections.fibers.LOGIC:
			logic += amount

	_update_resources()


func add_gold(amount: int) -> void:
	gold += amount
	_update_resources()


func spend_resource(faction: Collections.fibers, value: int) -> void:
	match faction:
		Collections.fibers.PASSION:
			passion -= value
		Collections.fibers.IMAGINATION:
			imagination -= value
		Collections.fibers.GROWTH:
			growth -= value
		Collections.fibers.LOGIC:
			logic -= value

	_update_resources()


@rpc("call_remote")
func refresh(gold_gained: int) -> void:
	gold = gold_gained

	_update_resources()


func get_resources() -> Dictionary:
	return {
		Collections.fibers.PASSION: passion,
		Collections.fibers.IMAGINATION: imagination,
		Collections.fibers.GROWTH: growth,
		Collections.fibers.LOGIC: logic,
	}


func _update_resources() -> void:
	if GameManager.is_single_player:
		GameManager.resource_bars[resources_owner_id].set_resources_labels(
			gold, passion, imagination, growth, logic
		)
	else:
		for p_id in GameManager.players:
			BattleSynchronizer.set_resources.rpc_id(
				p_id, resources_owner_id, gold, passion, imagination, growth, logic
			)
