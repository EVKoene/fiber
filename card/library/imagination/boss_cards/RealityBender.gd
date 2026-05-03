extends BossCard

class_name RealityBender


var stat_to_increase := 0

var targeted_ps := []
var card_to_steal: CardInPlay

func _init() -> void:
	boss_abilities = {
		0: {
			"ID": "ADD_1_TO_RANDOM_STAT",
			"WeightFactor": 3,
			"Func": func(): add_1_to_random_stat(),
			"Prepare": func(): prepare_add_1_to_random_stat(),
			"Text": null,
			"MinTurn": 0,
			"MaxTurn": -1,
			"Cleanup": func(): cleanup_add_1_to_random_stat(),
		},
		1: {
			"ID": "CREATE_INSPIRING_ARTIS",
			"WeightFactor": 3,
			"Func": func(): AIHelper.create_units_from_dummies(dummies),
			"Prepare": func(): prepare_adjacent_dummies(1, CardDatabase.cards.INSPIRING_ARTIST),
			"Text": "Create an Inspiring Artist in an adjacent playspace",
			"MinTurn": 1,
			"MaxTurn": -1,
			"Cleanup": func(): AIHelper.cleanup_dummies(dummies, dummies_ps),
		},
		2: {
			"ID": "DEAL_1_IN_ROWS_AND_COLUMNS",
			"WeightFactor": 3,
			"Func": func(): deal_1_in_rows_and_columns(),
			"Prepare": func(): prepare_deal_1_in_rows_and_columns(),
			"Text": "Deal 1 damage to all enemy units in the same row and column",
			"MinTurn": 2,
			"MaxTurn": -1,
			"Cleanup": func(): cleanup_deal_1_in_rows_and_columns()
		},
		3: {
			"ID": "CREATE_HOMONCULUS",
			"WeightFactor": 2,
			"Func": func(): AIHelper.create_units_from_dummies(dummies),
			"Prepare": func(): prepare_adjacent_dummies(1, CardDatabase.cards.HOMUNCULUS),
			"Text": "Create 1 Homonculus",
			"MinTurn": 3,
			"MaxTurn": 5,
			"Cleanup": func(): AIHelper.cleanup_dummies(dummies, dummies_ps),
		},
		4: {
			"ID": "ADD_1_MOVEMENT_TO_ALL",
			"WeightFactor": 1,
			"Func": func(): add_1_movement_to_all_units(),
			"Prepare": func(): prepare_add_1_movement_to_all_units(),
			"Text": "Add 1 movement to all units",
			"MinTurn": 4,
			"MaxTurn": -1,
			"Cleanup": func(): cleanup_add_1_movement_to_all_units(),
		},
		5: {
			"ID": "STEAL_CLOSEST_UNIT",
			"WeightFactor": 2,
			"Func": func(): steal_closest_unit(),
			"Prepare": func(): prepare_steal_closest_unit(),
			"Text": "Steal the closest enemy unit",
			"MinTurn": 2,
			"MaxTurn": -1,
			"Cleanup": func(): cleanup_steal_closest_unit(),
		},
	}
#

func prepare_add_1_to_random_stat() -> void:
	stat_to_increase = [
		Collections.stats.MAX_ATTACK, Collections.stats.MIN_ATTACK, Collections.stats.HEALTH, 
		Collections.stats.MOVEMENT, Collections.stats.ATTACK_RANGE, Collections.stats.SHIELD
	].pick_random()
	
	boss_abilities[0]["Text"] = "Add 1 to %s" % Collections.stat_names[stat_to_increase]
	
	highlight_stat(stat_to_increase)


func add_1_to_random_stat() -> void:
	CardManipulation.change_battle_stat(
		stat_to_increase, card_owner_id, card_in_play_index, 1, -1
	)


func cleanup_add_1_to_random_stat() -> void:
	for s in range(len(Collections.stats)):
		hide_stat_border(s)


func prepare_deal_1_in_rows_and_columns() -> void:
	for ps in GameManager.play_spaces:
		if ps.column != column and ps.row != row:
			continue
		
		targeted_ps.append(ps)
		ps.targeted_for_damage = true
		ps.modulate = ps.get_playspace_color()
	

func deal_1_in_rows_and_columns() -> void:
	for ps in GameManager.play_spaces:
		if ps.column != column and ps.row != row:
			continue
	
		PlaySpaceEffect.burn_play_space(ps, 1, card_owner_id, true)


func cleanup_deal_1_in_rows_and_columns() -> void:
	for ps in targeted_ps:
		ps.targeted_for_damage = false
		ps.modulate = ps.get_playspace_color()
	
	targeted_ps = []


func prepare_add_1_movement_to_all_units() -> void:
	for c in GameManager.cards_in_play[card_owner_id]:
		c.highlight_stat(Collections.stats.MOVEMENT)


func add_1_movement_to_all_units() -> void:
	for c in GameManager.cards_in_play[card_owner_id]:
		CardManipulation.change_battle_stat(
			Collections.stats.MOVEMENT, card_owner_id, card_in_play_index, 1, -1
		)


func cleanup_add_1_movement_to_all_units() -> void:
	for c in GameManager.cards_in_play[card_owner_id]:
		c.hide_stat_border(Collections.stats.MOVEMENT)


func prepare_steal_closest_unit() -> void:
	if len(GameManager.cards_in_play[GameManager.opposing_player_id(card_owner_id)]) == 0:
		return
	
	card_to_steal = CardHelper.closest_enemy_units(self).pick_random()
	card_to_steal.modulate = Color(0.56, 0.0, 1.0)


func steal_closest_unit() -> void:
	if len(GameManager.cards_in_play[GameManager.opposing_player_id(card_owner_id)]) == 0:
		return
	
	var target: CardInPlay = CardHelper.closest_enemy_units(self).pick_random()
	target.highlight_card()
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


func cleanup_steal_closest_unit() -> void:
	if !card_to_steal:
		return
	
	card_to_steal.modulate = Color(1, 1, 1, 1)
	card_to_steal = null


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if next_boss_ability["ID"] in ["CREATE_INSPIRING_ARTIST"]:
		if (
			trigger == Collections.triggers.CARD_MOVED and triggering_card == self
		):
			prepare_adjacent_dummies(1, CardDatabase.cards.HOMUNCULUS)
		if (
			trigger == Collections.triggers.CARD_MOVED 
			and triggering_card.current_play_space in dummies_ps
		):
			prepare_adjacent_dummies(1, CardDatabase.cards.INSPIRING_ARTIST)
	
	if next_boss_ability["ID"] == "DEAL_1_IN_ROWS_AND_COLUMNS":
		if (
			trigger == Collections.triggers.CARD_MOVED and triggering_card == self
		):
			cleanup_deal_1_in_rows_and_columns()
			prepare_deal_1_in_rows_and_columns()
	
	
	if (
		next_boss_ability["ID"] == "ADD_1_MOVEMENT_TO_ALL" 
		and trigger == Collections.triggers.CARD_MOVED
		and triggering_card.card_owner_id == card_owner_id
	):
		prepare_add_1_movement_to_all_units()
	
	if next_boss_ability["ID"] == "STEAL_CLOSEST_UNIT" and trigger in [
		Collections.triggers.CARD_CREATED, Collections.triggers.CARD_DESTROYED, 
		Collections.triggers.CARD_MOVED
	]:
		cleanup_steal_closest_unit()
		prepare_steal_closest_unit()
