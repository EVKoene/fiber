extends CardInPlay


class_name SkonInsectFather


func _init():
	abilities = [
		{
			"FuncName": "create_insects",
			"FuncText": "Create Insects",
			"AbilityCosts": Costs.new(0, 0, 0, 0),
		},
	]


func create_insects() -> bool:
	for ps in current_play_space.adjacent_play_spaces():
		var insect_triggered_funcs: Array = [
			{
				"FuncName": "frenzy",
				"FuncArguments": {},
			},
			{
				"FuncName": "damage_self",
				"FuncArguments": {
					"Trigger": Collections.triggers.ATTACK_FINISHED,
					"Damage": 1
				}
			}
		]
		
		var insect_img_path = "res://library/animal/images/Insect.png"
		if !ps.card_in_this_play_space:
			if GameManager.lobby.is_single_player:
				BattleManager.create_fabrication(
					card_owner_id, ps.column, ps.row, "Insect", 1, 1, 1, 1, 
					insect_triggered_funcs, insect_img_path, [Collections.factions.ANIMAL], {
						Collections.factions.ANIMAL: 1,
						Collections.factions.MAGIC: 0,
						Collections.factions.NATURE: 0,
						Collections.factions.ROBOT: 0,
					})
			if !GameManager.lobby.is_single_player:
				for p_id in GameManager.lobby.players:
					BattleManager.create_fabrication.rpc_id(
						p_id, card_owner_id, ps.column, ps.row, "Insect", 1, 1, 1, 1, 
						insect_triggered_funcs, insect_img_path, [Collections.factions.ANIMAL], {
							Collections.factions.ANIMAL: 1,
							Collections.factions.MAGIC: 0,
							Collections.factions.NATURE: 0,
							Collections.factions.ROBOT: 0,
						}
					)
			
	exhaust()

	return true


func resolve_ability_for_ai() -> void:
	create_insects()
	Events.card_ability_resolved_for_ai.emit()


func is_ability_to_use_now() -> bool:
	if (
		CardHelper.n_cards_in_adjacent_play_spaces(self, TargetSelection.target_restrictions.ANY_UNITS) 
		< len(current_play_space.adjacent_play_spaces())
	):
		return true
	else:
		return false
