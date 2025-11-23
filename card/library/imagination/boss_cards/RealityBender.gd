extends CardInPlay

class_name RealityBender


func _init() -> void:
	boss_abilities = {
		0: {
			"WeightFactor": 3,
			"Func": "add_1_to_random_stat",
			"Text": "Add 1 to max attack, min attack, health, shield, range or movement",
			"MinTurn": 0,
			"MaxTurn": -1,
		},
		1: {
			"WeightFactor": 3,
			"Func": "create_1_inspiring_artist",
			"Text": "Create an Inspiring Artist in an adjacent playspace",
			"MinTurn": 1,
			"MaxTurn": -1,
		},
		2: {
			"WeightFactor": 3,
			"Func": "deal_1_in_rows_and_columns",
			"Text": "Deal 1 damage to all enemy units in the same row and column",
			"MinTurn": 2,
			"MaxTurn": -1,
		},
		3: {
			"WeightFactor": 2,
			"Func": "create_1_homunculus",
			"Text": "Create 1 Homonculus",
			"MinTurn": 3,
			"MaxTurn": 5,
		},
		4: {
			"WeightFactor": 1,
			"Func": "add_1_movement_to_all_units",
			"Text": "Add 1 movement to all units",
			"MinTurn": 4,
			"MaxTurn": -1,
		},
		5: {
			"WeightFactor": 2,
			"Func": "steal_closest_unit",
			"Text": "Steal the closest enemy unit",
			"MinTurn": 2,
			"MaxTurn": -1,
		}
		
	}


func add_1_to_random_stat() -> String:
	var stat_to_increase: int = (
		[
			Collections.stats.MAX_ATTACK, Collections.stats.MIN_ATTACK, Collections.stats.HEALTH, 
			Collections.stats.MOVEMENT, Collections.stats.ATTACK_RANGE, Collections.stats.SHIELD
		]
		. pick_random()
	)

	CardManipulation.change_battle_stat(
		stat_to_increase, card_owner_id, card_in_play_index, 1, -1
	)
	
	return str("Add 1 to ", Collections.stat_names[stat_to_increase])


func create_1_inspiring_artist() -> String:
	var ps_options := []
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_space:
			ps_options.append(ps)
	
	var ps_to_play: PlaySpace = ps_options.pick_random()
	
	if GameManager.is_single_player:
		BattleSynchronizer.play_unit(
			CardDatabase.cards.INSPIRING_ARTIST, card_owner_id, ps_to_play.column, ps_to_play.row
				)
	else:
		for p_id in GameManager.players:
			BattleSynchronizer.play_unit.rpc_id(
				p_id, CardDatabase.cards_info.INSPIRING_ARTIST, card_owner_id, ps_to_play.column, 
				ps_to_play.row
			)
	
	exhaust()
	
	return "Create an Inspiring Artist in an adjacent playspace"


func deal_1_in_rows_and_columns() -> String:
	for ps in GameManager.play_spaces:
		if ps.column != column and ps.row != row:
			continue
	
		if GameManager.is_single_player:
			BattleAnimation.play_burn_animation(ps.column, ps.row)
		if !GameManager.is_single_player:
			for p_id in GameManager.players:
				BattleAnimation.play_burn_animation.rpc_id(p_id, ps.column, ps.row)

		var play_space: PlaySpace = GameManager.ps_column_row[ps.column][ps.row]
		if play_space.card_in_this_play_space:
			if play_space.card_in_this_play_space.card_owner_id != card_owner_id:
				play_space.card_in_this_play_space.resolve_damage(1)
				
	return "Deal 1 damage in rows and columns"


func create_1_homunculus() -> String:
	var ps_options := []
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_space:
			ps_options.append(ps)
	
	var ps_to_play: PlaySpace = ps_options.pick_random()
	
	if GameManager.is_single_player:
		BattleSynchronizer.play_unit(
			CardDatabase.cards.HOMUNCULUS, card_owner_id, ps_to_play.column, ps_to_play.row
				)
	else:
		for p_id in GameManager.players:
			BattleSynchronizer.play_unit.rpc_id(
				p_id, CardDatabase.cards_info.HOMUNCULUS, card_owner_id, ps_to_play.column, 
				ps_to_play.row
			)
	
	exhaust()
	
	return "Create 1 homonculus"


func add_1_movement_to_all_units() -> String:
	for c in GameManager.cards_in_play[card_owner_id]:
		CardManipulation.change_battle_stat(
			Collections.battle_stats.MOVEMENT, card_owner_id, card_in_play_index, 1, -1
		)
	
	return "Add 1 movement to all units"


func steal_closest_unit() -> String:
	if len(GameManager.cards_in_play[GameManager.opposing_player_id(card_owner_id)]) == 0:
		return "Steal the closest unit"
	
	var target: CardInPlay = CardHelper.closest_enemy_units(self).pick_random()
	target.highlight_card(true)
	target.card_owner_id = card_owner_id
	GameManager.cards_in_play[GameManager.player_id].erase(target)
	GameManager.cards_in_play[card_owner_id].append(target)
	if (
		(GameManager.is_player_1 and card_owner_id == GameManager.p2_id)
		or (!GameManager.is_player_1 and card_owner_id == GameManager.p1_id)
	):
		target.flip_card()
	else:
		target.unflip_card()
	
	return "Steal the closest unit"
