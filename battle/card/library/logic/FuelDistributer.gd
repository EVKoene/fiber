extends CardInPlay


class_name FuelDistributer


func _init():
	abilities = [
		{
			"FuncName": "fuel_adjacent",
			"FuncText": "Fuel adjacent units",
			"AbilityCosts": Costs.new(0, 0, 0, 1),
		},
	]


func fuel_adjacent() -> bool:
	assert(
		GameManager.resources[card_owner_id].logic >= 1, 
		"Insufficient resources to use Fuel Distributor ability"
	)
	GameManager.resources[card_owner_id].spend_resource(Collections.fibers.LOGIC, 1)
	for ps in current_play_space.adjacent_play_spaces():
		if ps.card_in_this_play_space and ps.card_in_this_play_space.card_owner_id == card_owner_id:
			CardManipulation.change_battle_stat(
				Collections.stats.HEALTH, card_owner_id, card_in_play_index, 1, 2
			)
			CardManipulation.change_battle_stat(
				Collections.stats.MIN_ATTACK, card_owner_id, card_in_play_index, 1, 2
			)
			CardManipulation.change_battle_stat(
				Collections.stats.MAX_ATTACK, card_owner_id, card_in_play_index, 1, 2
			)
			CardManipulation.change_battle_stat(
				Collections.stats.MOVEMENT, card_owner_id, card_in_play_index, 1, 2
			)
	
	return true


func resolve_ability_for_ai() -> void:
	fuel_adjacent()


func is_ability_to_use_now() -> bool:
	for ps in current_play_space.adjacent_play_spaces():
		if (
			ps.card_in_this_play_space 
			and ps.card_in_this_play_space.card_owner_id == card_owner_id
			and GameManager.resources 
		):
			return true
	
	return false
