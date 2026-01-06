extends CardInPlay

class_name Zaia


var botano_gardener_dummy: Card
var botano_gardener_ps: PlaySpace
var dinosaur_egg_dummies := []
var dinosaur_egg_ps := []
var protector_dummy: Card
var protector_ps: PlaySpace


func _init() -> void:
	boss_abilities = {
		0: {
			"WeightFactor": 3,
			"Func": "add_3_health",
			"Prepare": "prepare_add_3_health",
			"Text": "Add 3 health",
			"MinTurn": 0,
			"MaxTurn": 4,
			"Cleanup": "cleanup_add_3_health",
		},
		
		1: {
			"WeightFactor": 2,
			"Func": "create_1_botano_gardener",
			"Prepare": "prepare_1_botano_gardener",
			"Text": "Create 1 Botano Gardener in an adjacent playspace, then exhaust",
			"MinTurn": 0,
			"MaxTurn": 3,
			"Cleanup": "cleanup_create_1_botano_gardener",
		},
		
		2: {
			"WeightFactor": 2,
			"Func": "create_1_dinosaur_egg",
			"Prepare": "prepare_1_dinosaur_egg",
			"Text": "Create a dinosaur egg in an adjacent playspace, then exhaust",
			"MinTurn": 2,
			"MaxTurn": 4,
			"Cleanup": "cleanup_dinosaur_eggs",
		},
		
		3: {
			"WeightFactor": 2,
			"Func": "add_5_health_1_movement",
			"Prepare": "prepare_add_5_health_1_movement",
			"Text": "Add 5 health and 1 movement",
			"MinTurn": 5,
			"MaxTurn": -1,
			"Cleanup": "cleanup_add_5_health_1_movement",
		},
		
		4: {
			"WeightFactor": 2,
			"Func": "create_1_protector",
			"Prepare": "prepare_1_protector",
			"Text": "Create 1 protector of the forest in an adjacent playspace, then exhaust",
			"MinTurn": 5,
			"MaxTurn": -1,
			"Cleanup": "cleanup_1_protector",
		},
		
		5: {
			"WeightFactor": 2,
			"Func": "create_2_dinosaur_eggs",
			"Prepare": "prepare_2_dinosaur_eggs",
			"Text": "Create 2 dinosaur eggs in adjacent playspaces, then exhaust",
			"MinTurn": 5,
			"MaxTurn": -1,
			"Cleanup": "cleanup_dinosaur_eggs",
		},
	}

func prepare_add_3_health() -> void:
	highlight_stat(Collections.stats.HEALTH)


func add_3_health() -> void:
	CardManipulation.change_battle_stat(
		Collections.stats.HEALTH, card_owner_id, card_in_play_index, 3, -1
	)


func cleanup_add_3_health() -> void:
	hide_stat_border(Collections.stats.HEALTH)


func prepare_1_botano_gardener() -> void:
	cleanup_create_1_botano_gardener()
	
	var ps_options := []
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_space:
			ps_options.append(ps)
	
	if len(ps_options) >= 1:
		botano_gardener_ps = ps_options.pick_random()
		botano_gardener_dummy = CardManipulation.show_card_dummy(
			CardDatabase.cards.BOTANO_GARDENER, botano_gardener_ps
		)


func create_1_botano_gardener() -> void:
	if GameManager.is_single_player:
		BattleSynchronizer.play_unit(
			CardDatabase.cards.BOTANO_GARDENER, card_owner_id, botano_gardener_ps.column, 
			botano_gardener_ps.row
		)
	else:
		for p_id in GameManager.players:
			BattleSynchronizer.play_unit.rpc_id(
				p_id, CardDatabase.cards_info.BOTANO_GARDENER, card_owner_id, 
				botano_gardener_ps.column, botano_gardener_ps.row
			)
	
	exhaust()
	

func cleanup_create_1_botano_gardener() -> void:
	if botano_gardener_dummy:
		botano_gardener_dummy.queue_free()
		botano_gardener_dummy = null
		botano_gardener_ps = null


func prepare_1_dinosaur_egg() -> void:
	cleanup_dinosaur_eggs()
	
	var ps_options := []
	
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_space:
			ps_options.append(ps)
	
	if len(ps_options) >= 1:
		dinosaur_egg_ps.append(ps_options.pick_random())
		dinosaur_egg_dummies.append(
			CardManipulation.show_card_dummy(
				CardDatabase.cards.DINOSAUR_EGG, dinosaur_egg_ps[0]
			)
		)


func create_1_dinosaur_egg() -> void:
	if GameManager.is_single_player:
		BattleSynchronizer.play_unit(
			CardDatabase.cards.DINOSAUR_EGG, card_owner_id, dinosaur_egg_ps[0].column, 
			dinosaur_egg_ps[0].row
		)
	else:
		for p_id in GameManager.players:
			BattleSynchronizer.play_unit.rpc_id(
				p_id, CardDatabase.cards_info.DINOSAUR_EGG, card_owner_id, 
				dinosaur_egg_ps[0].column, dinosaur_egg_ps[0].row
			)
	
	exhaust()
	

func cleanup_dinosaur_eggs() -> void:
	if len(dinosaur_egg_dummies) > 0:
		for egg in dinosaur_egg_dummies:
			egg.queue_free()
		dinosaur_egg_dummies = []
	
	dinosaur_egg_ps = []


func prepare_add_5_health_1_movement() -> void:
	highlight_stat(Collections.stats.HEALTH)
	highlight_stat(Collections.stats.MOVEMENT)


func add_5_health_1_movement() -> void:
	CardManipulation.change_battle_stat(
		Collections.stats.HEALTH, card_owner_id, card_in_play_index, 5, -1
	)
	CardManipulation.change_battle_stat(
		Collections.stats.MOVEMENT, card_owner_id, card_in_play_index, 1, -1
	)


func cleanup_add_5_health_1_movement() -> void:
	hide_stat_border(Collections.stats.HEALTH)
	hide_stat_border(Collections.stats.MOVEMENT)


func prepare_1_protector() -> void:
	cleanup_1_protector()
	
	var ps_options := []
	
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_spaces:
			ps_options.append(ps)
	
	if len(ps_options) >= 1:
		protector_ps = ps_options.pick_random()
		protector_dummy = CardManipulation.show_card_dummy(
			CardDatabase.cards.PROTECTOR_OF_THE_FOREST, protector_ps
		)


func create_1_protector() -> void:
	if GameManager.is_single_player:
		BattleSynchronizer.play_unit(
			CardDatabase.cards.PROTECTOR_OF_THE_FOREST, card_owner_id, protector_ps.column, 
			protector_ps.row
		)
	else:
		for p_id in GameManager.players:
			BattleSynchronizer.play_unit.rpc_id(
				p_id, CardDatabase.cards_info.PROTECTOR_OF_THE_FOREST, card_owner_id, 
				protector_ps.column, protector_ps.row
			)
	
	exhaust()
	

func cleanup_1_protector() -> void:
	if protector_dummy != null:
		protector_dummy.queue_free()
		protector_dummy = null


func prepare_2_dinosaur_eggs() -> void:
	cleanup_dinosaur_eggs()
	
	var ps_options := []
	var dummies_shown := 0
	
	for ps in current_play_space.adjacent_play_spaces():
		if !ps.card_in_this_play_space:
			ps_options.append(ps)
	
	match len(ps_options):
		0:
			pass
		1:
			dinosaur_egg_dummies.append(
				CardManipulation.show_card_dummy(CardDatabase.cards.DINOSAUR_EGG, ps_options[0])
			)
		_:
			ps_options.shuffle()
			dinosaur_egg_dummies.append(
				CardManipulation.show_card_dummy(CardDatabase.cards.DINOSAUR_EGG, ps_options[0])
			)
			dinosaur_egg_dummies.append(
				CardManipulation.show_card_dummy(CardDatabase.cards.DINOSAUR_EGG, ps_options[1])
			)


func create_2_dinosaur_eggs() -> void:
	for egg in dinosaur_egg_ps:
		if GameManager.is_single_player:
			BattleSynchronizer.play_unit(
				CardDatabase.cards.DINOSAUR_EGG, card_owner_id, egg.column, 
				egg.row
			)
		else:
			for p_id in GameManager.players:
				BattleSynchronizer.play_unit.rpc_id(
					p_id, CardDatabase.cards_info.DINOSAUR_EGG, card_owner_id, 
					egg.column, egg.row
				)
	
	exhaust()


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if trigger == Collections.triggers.CARD_MOVED and triggering_card == self:
		match next_boss_ability["Func"]:
			"create_1_dinosaur_egg":
				prepare_1_dinosaur_egg()
			"create_1_botano_gardener":
				prepare_1_botano_gardener()
			"create_1_protector":
				prepare_1_protector()
			"create_2_dinosaur_eggs":
				prepare_2_dinosaur_eggs()
			_:
				pass
