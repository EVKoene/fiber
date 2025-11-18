extends CardInPlay

class_name FanaticLeader


func _init() -> void:
	boss_abilities = {
		0: {
			"WeightFactor": 3,
			"Func": "create_3_followers",
			"Text": "Create up to 3 Fanatic Followers in adjacent playspaces and exhaust",
			"MinTurn": 0,
			"MaxTurn": -1,
		},
		1: {
			"WeightFactor": 3,
			"Func": "deal_1_damage_to_all_in_range_5",
			"Text": "Deal 1 damage to each enemy unit in a range of 3, ignoring any obstacles",
			"MinTurn": 1,
			"MaxTurn": -1,
		},
		2: {
			"WeightFactor": 3,
			"Func": "deal_3_damage_to_closest",
			"Text": "Deal 2 damage to the closest enemy unit",
			"MinTurn": 2,
			"MaxTurn": -1,
		},
		3: {
			"WeightFactor": 2,
			"Func": "create_1_berserker",
			"Text": "Create 1 Warthog Berserker",
			"MinTurn": 3,
			"MaxTurn": 5,
		},
		4: {
			"WeightFactor": 1,
			"Func": "create_2_berserkers",
			"Text": "Create 2 Warthog Berserkers",
			"MinTurn": 4,
			"MaxTurn": -1,
		},
		5: {
			"WeightFactor": 1,
			"Func": "create_2_cheetahs",
			"Text": "Create 2 Cheetahs",
			"MinTurn": 6,
			"MaxTurn": -1,
		}
		
	}


func create_3_followers() -> void:
	var followers_created := 0
	for ps in current_play_space.adjacent_play_spaces():
		if followers_created >= 3:
			continue
		
		if !ps.card_in_this_play_space:
			if GameManager.is_single_player:
				BattleSynchronizer.play_unit(
					CardDatabase.cards.FANATIC_FOLLOWER, card_owner_id, ps.column, ps.row
				)
			else:
				for p_id in GameManager.players:
					BattleSynchronizer.play_unit.rpc_id(
						p_id, CardDatabase.cards_info.FANATIC_FOLLOWER, card_owner_id, ps.column, 
						ps.row
					)
		followers_created += 1
	exhaust()


func deal_1_damage_to_all_in_range_5() -> void:
	if len(GameManager.cards_in_play[GameManager.opposing_player_id(card_owner_id)]) == 0:
		return
		
	for c in GameManager.cards_in_play[GameManager.opposing_player_id(card_owner_id)]:
		if c.current_play_space in spaces_in_range(3, true):
			await deal_damage_to_card(c, 1)


func deal_3_damage_to_closest() -> void:
	if len(GameManager.cards_in_play[GameManager.opposing_player_id(card_owner_id)]) == 0:
		return
	
	await deal_damage_to_card(
		CardHelper.closest_enemy_units(self).pick_random(), 2
	)

func create_1_berserker() -> void:
	var ps_options := []
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_space:
			ps_options.append(ps)
	
	var ps_to_play: PlaySpace = ps_options.pick_random()
	
	if GameManager.is_single_player:
		BattleSynchronizer.play_unit(
			CardDatabase.cards.WARTHOG_BERSERKER, card_owner_id, ps_to_play.column, ps_to_play.row
				)
	else:
		for p_id in GameManager.players:
			BattleSynchronizer.play_unit.rpc_id(
				p_id, CardDatabase.cards_info.WARTHOG_BERSERKER, card_owner_id, ps_to_play.column, 
				ps_to_play.row
			)
	
	exhaust()


func create_2_berserkers() -> void:
	var berserkers_created := 0
	for ps in current_play_space.adjacent_play_spaces():
		if berserkers_created >= 2:
			continue
		
		if !ps.card_in_this_play_space:
			if GameManager.is_single_player:
				BattleSynchronizer.play_unit(
					CardDatabase.cards.WARTHOG_BERSERKER, card_owner_id, ps.column, ps.row
				)
			else:
				for p_id in GameManager.players:
					BattleSynchronizer.play_unit.rpc_id(
						p_id, CardDatabase.cards_info.WARTHOG_BERSERKER, card_owner_id, ps.column, 
						ps.row
					)
		berserkers_created += 1
	exhaust()


func create_2_cheetahs() -> void:
	var cheetahs_created := 0
	for ps in current_play_space.adjacent_play_spaces():
		if cheetahs_created >= 2:
			continue
		
		if !ps.card_in_this_play_space:
			if GameManager.is_single_player:
				BattleSynchronizer.play_unit(
					CardDatabase.cards.CHEETAH, card_owner_id, ps.column, ps.row
				)
			else:
				for p_id in GameManager.players:
					BattleSynchronizer.play_unit.rpc_id(
						p_id, CardDatabase.cards_info.CHEETAH, card_owner_id, ps.column, 
						ps.row
					)
		cheetahs_created += 1
	exhaust()
