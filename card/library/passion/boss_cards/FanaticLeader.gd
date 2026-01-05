extends BossCard

class_name FanaticLeader


var cards_to_deal_1_damage := []

var card_to_deal_3_damage: CardInPlay


func _init() -> void:
	boss_abilities = {
		0: {
			"ID": "CREATE_2_FOLLOWERS",
			"WeightFactor": 2,
			"Func": func(): create_units(),
			"Prepare": func(): prepare_adjacent_dummies(2, CardDatabase.cards.FANATIC_FOLLOWER),
			"Text": "Create up to 2 Fanatic Followers in adjacent playspaces and exhaust",
			"MinTurn": 0,
			"MaxTurn": -1,
			"Cleanup": func(): cleanup_dummies()
		},
		1: {
			"ID": "CREATE_3_FOLLOWERS",
			"WeightFactor": 3,
			"Func": func(): create_units(),
			"Prepare": func(): prepare_adjacent_dummies(3, CardDatabase.cards.FANATIC_FOLLOWER),
			"Text": "Create up to 3 Fanatic Followers in adjacent playspaces and exhaust",
			"MinTurn": 2,
			"MaxTurn": 8,
			"Cleanup": func(): cleanup_dummies()
		},
		2: {
			"ID": "DEAL_1_IN_RANGE_3",
			"WeightFactor": 3,
			"Func": func(): deal_1_damage_to_all_in_range_3(),
			"Prepare": func(): prepare_deal_1_damage_to_all_in_range_3(),
			"Text": "Deal 1 damage to each enemy unit in a range of 3, ignoring any obstacles",
			"MinTurn": 1,
			"MaxTurn": -1,
			"Cleanup": func(): cleanup_deal_1_damage_to_all_in_range_3()
		},
		3: {
			"ID": "DEAL_3_TO_CLOSEST",
			"WeightFactor": 3,
			"Prepare": func(): prepare_deal_3_damage_to_closest(),
			"Func": func(): deal_3_damage_to_closest(),
			"Text": "Deal 2 damage to the closest enemy unit",
			"MinTurn": 2,
			"MaxTurn": -1,
			"Cleanup": func(): cleanup_3_damage_to_closest()
		},
		4: {
			"ID": "CREATE_WARTHOG_BERSERKER",
			"WeightFactor": 2,
			"Prepare": func(): prepare_adjacent_dummies(1, CardDatabase.cards.WARTHOG_BERSERKER),
			"Func": func(): create_units(),
			"Text": "Create 1 Warthog Berserker",
			"MinTurn": 3,
			"MaxTurn": 5,
			"Cleanup": func(): cleanup_dummies(),
		},
		5: {
			"ID": "CREATE_2_WARTHOG_BERSERKERS",
			"WeightFactor": 1,
			"Prepare": func(): prepare_adjacent_dummies(2, CardDatabase.cards.WARTHOG_BERSERKER),
			"Func": func(): create_units(),
			"Text": "Create 2 Warthog Berserkers",
			"MinTurn": 6,
			"MaxTurn": -1,
			"Cleanup": func(): cleanup_dummies()
		},
		6: {
			"ID": "CREATE_CHEETAH",
			"WeightFactor": 1,
			"Prepare": func(): prepare_adjacent_dummies(1, CardDatabase.cards.CHEETAH),
			"Func": func(): create_units(),
			"Text": "Create 2 Cheetahs",
			"MinTurn": 8,
			"MaxTurn": -1,
			"Cleanup": func(): cleanup_dummies()
		},
		7: {
			"ID": "CREATE_2_CHEETAHS",
			"WeightFactor": 1,
			"Prepare": func(): prepare_adjacent_dummies(2, CardDatabase.cards.CHEETAH),
			"Func": func(): create_units(),
			"Text": "Create 2 Cheetahs",
			"MinTurn": 6,
			"MaxTurn": -1,
			"Cleanup": func(): cleanup_dummies()
		}
		
	}


func prepare_deal_1_damage_to_all_in_range_3() -> void:
	cleanup_deal_1_damage_to_all_in_range_3()
	if len(GameManager.cards_in_play[GameManager.opposing_player_id(card_owner_id)]) == 0:
		return
	
	for c in GameManager.cards_in_play[GameManager.opposing_player_id(card_owner_id)]:
		if c.current_play_space in spaces_in_range(3, true):
			c.targeted_for_damage = true
			cards_to_deal_1_damage.append(c)
			c.modulate = c.get_card_color()


func deal_1_damage_to_all_in_range_3() -> void:
	if len(cards_to_deal_1_damage) == 0:
		return
		
	for c in cards_to_deal_1_damage:
		await deal_damage_to_card(c, 1)


func cleanup_deal_1_damage_to_all_in_range_3() -> void:
	for c in cards_to_deal_1_damage:
		if is_instance_valid(c):
			c.targeted_for_damage = false
			c.modulate = c.get_card_color()
	
	cards_to_deal_1_damage = []


func prepare_deal_3_damage_to_closest() -> void:
	cleanup_3_damage_to_closest()
	if len(GameManager.cards_in_play[GameManager.opposing_player_id(card_owner_id)]) == 0:
		return
	
	card_to_deal_3_damage = CardHelper.closest_enemy_units(self).pick_random()
	card_to_deal_3_damage.targeted_for_damage = true
	card_to_deal_3_damage.modulate = card_to_deal_3_damage.get_card_color()


func deal_3_damage_to_closest() -> void:
	if card_to_deal_3_damage == null:
		return
	
	await deal_damage_to_card(card_to_deal_3_damage, 3)


func cleanup_3_damage_to_closest() -> void:
	if !card_to_deal_3_damage:
		return
	
	card_to_deal_3_damage.targeted_for_damage = false
	card_to_deal_3_damage.modulate = card_to_deal_3_damage.get_card_color()
	card_to_deal_3_damage = null


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if next_boss_ability["ID"] in [
		"CREATE_3_FOLLOWERS", "CREATE_3_FOLLOWERS", "CREATE_WARTHOG_BERSERKER", 
		"CREATE_2_WARTHOG_BERSERKERS", "CREATE_CHEETAH", "CREATE_2_CHEETAHS"
	]:
		if trigger in [Collections.triggers.CARD_MOVED] and triggering_card == self:
			next_boss_ability["Prepare"].call()
				
		if trigger in [
				Collections.triggers.CARD_MOVED, Collections.triggers.CARD_CREATED, 
				Collections.triggers.CARD_DESTROYED
		] and (
			triggering_card.column in dummy_columns
			or triggering_card.row in dummy_rows
		):
			next_boss_ability["Prepare"].call()
	
	if next_boss_ability["ID"] in ["DEAL_1_IN_RANGE_3", "DEAL_3_DAMAGE_TO_CLOSEST"] and trigger in [
		Collections.triggers.CARD_MOVED, Collections.triggers.CARD_CREATED, 
		Collections.triggers.CARD_DESTROYED
	]:
		next_boss_ability["Prepare"].call()
	
