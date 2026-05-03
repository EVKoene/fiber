extends NormalOpponent

class_name FireStorm

enum ability_ids { FIRE_GOLEMS_OR_ERUPTION }

var preparing_eruption := false
var play_spaces_to_erupt: Array[PlaySpace] = []


func _init() -> void:
	abilities = {
		0: {
			"ID": ability_ids.FIRE_GOLEMS_OR_ERUPTION,
			"WeightFactor": 1,
			"Func": func(): AIHelper.create_units_from_dummies(dummies),
			"Prepare": func(): prepare_golems_or_eruption(),
			"Text": "Create 3 fire golems",
			"MinTurn": 0,
			"MaxTurn": -1,
			"Cleanup": func(): AIHelper.cleanup_dummies(dummies, dummies_ps),
		},
	}


func prepare_golems_or_eruption() -> void:
	if GameManager.turn_manager.turn_count % 2 == 0:
		prepare_golems()
	else:
		prepare_eruption()


func prepare_golems() -> void:
	AIHelper.prepare_dummies(
		CardDatabase.cards.FIRE_GOLEM, dummies, [
			GameManager.ps_column_row[3][0], GameManager.ps_column_row[4][0], 
			GameManager.ps_column_row[5][0]
		], 3, GameManager.ai_player.player_id
	)


func prepare_eruption() -> void:
	assert(
		len(play_spaces_to_erupt) == 0, str(
			"play_spaces_to_erupt should be empty at the , is ", play_spaces_to_erupt
		)
	)
	
	preparing_eruption = true
	
	var starting_column := randi_range(0, MapSettings.n_columns - 3)
	var starting_row := randi_range(0, MapSettings.n_rows - 3)
	
	for col_offset in range(3):
		for row_offset in range(3):
			var col := starting_column + col_offset
			var row := starting_row + row_offset
			var ps_to_erupt: PlaySpace = GameManager.ps_column_row[col][row]
			
			ps_to_erupt.targeted_for_damage = true
			ps_to_erupt.modulate = ps_to_erupt.get_playspace_color()
			play_spaces_to_erupt.append(ps_to_erupt)


func erupt() -> void:
	for ps in play_spaces_to_erupt:
		PlaySpaceEffect.burn_play_space(ps, 3, GameManager.p2_id, true)
	
func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if (
		trigger == Collections.triggers.CARD_MOVED 
		and triggering_card.current_play_space in dummies_ps
		and !preparing_eruption
	):
		prepare_golems()
