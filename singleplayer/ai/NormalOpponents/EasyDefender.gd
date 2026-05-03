extends NormalOpponent

class_name EasyDefender

enum ability_ids {
	CREATE_OBSTRUCTION_CONSTRUCTION, CREATE_SNEK, CREATE_PROTECTOR_OF_THE_FOREST,
}


func _init() -> void:
	abilities = {
		0: {
			"ID": ability_ids.CREATE_OBSTRUCTION_CONSTRUCTION,
			"WeightFactor": 1,
			"Func": func(): AIHelper.create_units_from_dummies(dummies),
			"Prepare": func(): play_unit_in_empty_victory_space(
				CardDatabase.cards.OBSTRUCTION_CONSTRUCTION
			),
			"Text": "Create an Obstruction Construction",
			"MinTurn": 0,
			"MaxTurn": 1,
			"Cleanup": func(): AIHelper.cleanup_dummies(dummies, dummies_ps),
		},
		
		1: {
			"ID": ability_ids.CREATE_SNEK,
			"WeightFactor": 1,
			"Func": func(): AIHelper.create_units_from_dummies(dummies),
			"Prepare": func(): play_unit_in_empty_victory_space(CardDatabase.cards.SNEK),
			"Text": "Create a Snek",
			"MinTurn": 1,
			"MaxTurn": 3,
			"Cleanup": func(): AIHelper.cleanup_dummies(dummies, dummies_ps),
		},
		
		2: {
			"ID": ability_ids.CREATE_PROTECTOR_OF_THE_FOREST,
			"WeightFactor": 1,
			"Func": func(): AIHelper.create_units_from_dummies(dummies),
			"Prepare": func(): play_unit_in_empty_victory_space(
				CardDatabase.cards.PROTECTOR_OF_THE_FOREST
			),
			"Text": "Create an Obstruction Construction",
			"MinTurn": 3,
			"MaxTurn": -1,
			"Cleanup": func(): AIHelper.cleanup_dummies(dummies, dummies_ps),
		},
}


func play_unit_in_empty_victory_space(card_index: int) -> void:
	AIHelper.cleanup_dummies(dummies, dummies_ps)
	dummies_ps = find_empty_victory_spaces()
	if len(dummies_ps) >= 1:
		AIHelper.prepare_dummies(
			card_index, 
			dummies, 
			dummies_ps, 
			1,
			GameManager.ai_player.player_id
		)


func find_empty_victory_spaces() -> Array[PlaySpace]:
	var spaces: Array[PlaySpace] = []
	
	for ps in GameManager.victory_spaces:
		if !ps.card_in_this_play_space:
			spaces.append(ps)
	
	return spaces


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if (
		trigger == Collections.triggers.CARD_MOVED 
		and triggering_card.current_play_space in dummies_ps
	):
		match next_ability["ID"]:
			ability_ids.CREATE_OBSTRUCTION_CONSTRUCTION:
				play_unit_in_empty_victory_space(CardDatabase.cards.OBSTRUCTION_CONSTRUCTION)
			ability_ids.CREATE_SNEK:
				play_unit_in_empty_victory_space(CardDatabase.cards.SNEK)
			ability_ids.CREATE_PROTECTOR_OF_THE_FOREST:
				play_unit_in_empty_victory_space(CardDatabase.cards.PROTECTOR_OF_THE_FOREST)
			_:
				assert(false, str("Unknown ability id: ", next_ability["ID"]))
