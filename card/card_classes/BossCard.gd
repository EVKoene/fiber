extends CardInPlay


class_name BossCard


var dummies := []
var dummy_columns := []
var dummy_rows := []


func prepare_adjacent_dummies(n_dummies: int, card_index: int) -> void:
	cleanup_dummies()
	
	var ps_options := []
	var dummies_shown := 0
	
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_space:
			ps_options.append(ps)
	
	for ps in ps_options:
		if dummies_shown >= n_dummies:
			break
		dummies.append(
			CardManipulation.show_card_dummy(card_index, ps)
		)
		dummy_columns.append(ps.column)
		dummy_rows.append(ps.row)
		dummies_shown += 1


func cleanup_dummies() -> void:
	if len(dummies) > 0:
		for d in dummies:
			d.queue_free()
		dummies = []
	
	dummy_columns = []
	dummy_rows = []


func create_units() -> void:
	for dummy in dummies:
		if GameManager.is_single_player:
			BattleSynchronizer.play_unit(
				dummy.card_index, card_owner_id, dummy.column, dummy.row
			)
		else:
			for p_id in GameManager.players:
				BattleSynchronizer.play_unit.rpc_id(
					p_id, dummy.card_index, card_owner_id, dummy.column, 
					dummy.row
				)
	
	exhaust()
