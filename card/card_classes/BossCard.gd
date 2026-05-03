extends CardInPlay


class_name BossCard


var dummies: Array[Card]
var dummies_ps: Array[PlaySpace]
var dummy_columns: get = _get_dummy_columns
var dummy_rows: get = _get_dummy_rows
var boss_abilities := {}
var next_boss_ability := {}


func prepare_adjacent_dummies(n_dummies: int, card_index: int, cleanup_dummies: bool = true) -> void:
	if cleanup_dummies:
		AIHelper.cleanup_dummies(dummies, dummies_ps)
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_space:
			dummies_ps.append(ps)
	
	AIHelper.prepare_dummies(card_index, dummies, dummies_ps, n_dummies, card_owner_id)


func _get_dummy_columns() -> Array[int]:
	var columns := []
	for dummy in dummies:
		columns.append(dummy.current_play_space.column)
	
	return columns


func _get_dummy_rows() -> Array[int]:
	var rows := []
	for dummy in dummies:
		rows.append(dummy.current_play_space.row)
	
	return rows


func prepare_next_turn_boss_ability() -> void:
	# Always pick ability[0] as the first ability
	if len(next_boss_ability) == 0:
		next_boss_ability = boss_abilities[0]
	
	else:
		var abilities_to_pick_from := []
		for ability in boss_abilities.values():
			if ability["MinTurn"] > GameManager.ai_player.ai_turns + 1:
				continue
			if ability["MaxTurn"] < GameManager.ai_player.ai_turns + 1 and ability["MaxTurn"] != -1:
				continue
			
			for f in range(ability["WeightFactor"]):
				abilities_to_pick_from.append(ability)
		next_boss_ability = abilities_to_pick_from.pick_random()
	
	next_boss_ability["Prepare"].call()
