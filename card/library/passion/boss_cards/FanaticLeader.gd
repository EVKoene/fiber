extends CardInPlay

class_name FanaticLeader


func _init() -> void:
	boss_abilities = {
		0: {
			"WeightFactor": 1,
			"Func": "create_3_followers",
			"Text": "Create 3 Fanatic Followers in adjacent playspaces"
		},
		1: {
			"WeightFactor": 1,
			"Func": "deal_1_damage_to_all_in_range_5",
			"Text": "Deal 1 damage to each enemy unit in a range of 5, ignoring any obstacles"
		},
		2: {
			"WeightFactor": 1,
			"Func": "deal_3_damage_to_closest",
			"Text": "Deal 3 damage to the closest enemy unit"
		}
	}


func create_3_followers() -> void:
	for ps in current_play_space.adjacent_play_spaces():
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
	exhaust()


func deal_1_damage_to_all_in_range_5() -> void:
	for c in GameManager.cards_in_play[GameManager.opposing_player_id(card_owner_id)]:
		if c in spaces_in_range(5, true):
			deal_damage_to_card(c, 1)


func deal_3_damage_to_closest() -> void:
	deal_damage_to_card(
		CardHelper.closest_enemy_units(self).pick_random(), 3
	)
