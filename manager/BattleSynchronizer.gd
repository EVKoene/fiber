extends Node

"""
In this script you will find functions to synchronize the battlefield between players. If a player
creates or moves a card, the specified functions should be called here by both players with the
necessary information. This means we hardly use the multiplayer spawner or synchronizer, as both
client and server will create objects and execute functionality seperately. 
"""

@onready var card_in_play_scene: PackedScene = preload("res://battle/card/card_states/CardInPlay.tscn")
@onready var card_in_hand_scene: PackedScene = preload("res://battle/card/card_states/CardInHand.tscn")


@rpc("any_peer", "call_local")
func refresh_unit(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.modulate = Color(1, 1, 1, 1)
	card.exhausted = false


@rpc("any_peer", "call_local")
func exhaust_unit(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.modulate = Color(0.5, 0.5, 0.5, 1)
	card.exhausted = true


@rpc("any_peer", "call_local")
func resolve_damage(card_owner_id, cip_index, value):
	var min_value: int = max(0, value)
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	var damage_number = Label.new()
	card.add_child(damage_number)
	damage_number.scale *= MapSettings.card_in_play_size * 0.9 / damage_number.size 
	damage_number.text = str(min_value)
	damage_number.label_settings = LabelSettings.new()
	damage_number.label_settings.font_size = 100
	damage_number.label_settings.font_color = Color("f41700")
	await get_tree().create_timer(0.5).timeout
	# Return if the instance is no longer valid is mostly for the tutorial, because we destroy
	# cards to setup several scenarios
	if !is_instance_valid(card):
		return
	
	damage_number.queue_free()
	
	if min_value > 0:
		card.shake()
	
	if card.health - value > 0:
		CardManipulation.change_battle_stat(
			Collections.stats.HEALTH, card_owner_id, cip_index,-min_value, -1
		)
	elif card.health - value <= 0:
		if GameManager.is_single_player:
			CardManipulation.destroy(card.card_owner_id, card.card_in_play_index)
		if !GameManager.is_single_player:
			CardManipulation.destroy.rpc_id(
				GameManager.player_id, card.card_owner_id, card.card_in_play_index
			)


@rpc("any_peer", "call_local")
func play_unit(card_index: int, card_owner_id: int, column: int, row: int) -> void:
	var card: CardInPlay = card_in_play_scene.instantiate()
	card.set_script(CardDatabase.get_card_class(card_index))
	card.card_owner_id = card_owner_id
	card.card_index = card_index
	card.column = column
	card.row = row
	GameManager.cards_in_play[card_owner_id].append(card)
	GameManager.battle_map.add_child(card)
	GameManager.zoom_preview.reset_zoom_preview()


@rpc("any_peer", "call_local")
func create_fabrication(
	card_owner_id: int, column: int, row: int, ingame_name: String, max_attack: int, min_attack: int, 
	health: int, movement: int, triggered_funcs: Array, img_path: String, fibers: Array,
	costs: Dictionary, 
) -> void:
	var fabrication = card_in_play_scene.instantiate()
	fabrication.battle_stats = BattleStats.new(
		max_attack, min_attack, health, movement, fabrication
	)
	fabrication.fibers = fibers
	fabrication.ingame_name = ingame_name
	fabrication.card_owner_id = card_owner_id
	fabrication.column = column
	fabrication.row = row
	fabrication.triggered_funcs = triggered_funcs
	fabrication.img_path = img_path
	fabrication.fabrication = true
	fabrication.costs = Costs.new(
			costs[Collections.fibers.PASSION],
			costs[Collections.fibers.IMAGINATION],
			costs[Collections.fibers.GROWTH],
			costs[Collections.fibers.LOGIC],
	)
	GameManager.cards_in_play[card_owner_id].append(fabrication)
	GameManager.battle_map.add_child(fabrication)
	
	await get_tree().create_timer(0.1).timeout


@rpc("any_peer", "call_local")
func remove_card_from_hand(card_owner_id: int, hand_index: int) -> void:
	var card: CardInHand = GameManager.cards_in_hand[card_owner_id][hand_index]
	GameManager.cards_in_hand[card_owner_id].remove_at(hand_index)
	set_hand_card_positions()
	card.queue_free()


@rpc("any_peer", "call_local")
func update_play_space_stat_modifier(
	card_owner_id: int, column: int, row: int, stat: int, value: int
) -> void:
	var play_space: PlaySpace = GameManager.ps_column_row[column][row]
	play_space.stat_modifier[card_owner_id][stat] += value
	for p in GameManager.players:
		for c in GameManager.cards_in_play[p]:
			c.update_stats()


@rpc("any_peer", "call_local")
func create_hand_card(card_owner_id: int, card_index: int) -> void:
	var hand_card: CardInHand = card_in_hand_scene.instantiate()
	hand_card.card_index = card_index
	hand_card.card_owner_id = card_owner_id
	GameManager.battle_map.add_child(hand_card)


@rpc("any_peer", "call_local")
func add_to_territory(p_id: int, column: int, row: int) -> void:
	var play_space: PlaySpace = GameManager.ps_column_row[column][row]
	play_space.territory = Territory.new(p_id, play_space)
	GameManager.battle_map.add_child(play_space.territory)


@rpc("any_peer", "call_local")
func set_conquered_by(player_id: int, column: int, row: int) -> void:
	var play_space = GameManager.ps_column_row[column][row]
	play_space.conquered_by = player_id
	match player_id:
		GameManager.p1_id:
			play_space.get_theme_stylebox("panel").border_color = Styling.p1_color
		GameManager.p2_id:
			play_space.get_theme_stylebox("panel").border_color = Styling.p2_color
	
	if GameManager.is_single_player:
		set_progress_bars()
	
	if !GameManager.is_single_player:
		for p in GameManager.players:
			set_progress_bars.rpc_id(p)


@rpc("any_peer", "call_local")
func set_resources(
	resource_owner_id: int, gold: int, passion: int, imagination: int, growth: int, logic: int
) -> void:
	GameManager.resource_bars[resource_owner_id].set_resources_labels(
		gold, passion, imagination, growth, logic
	)


@rpc("any_peer", "call_local")
func set_progress_bars() -> void:
	for p_id in GameManager.players:
		var conquered_victory_spaces := 0
		for s in GameManager.victory_spaces:
			if !s.conquered_by:
				continue
			if s.conquered_by == p_id:
				conquered_victory_spaces += 1
		
		if (
			conquered_victory_spaces >= MapSettings.n_progress_bars 
			and GameManager.player_id == p_id
		):
			GameManager.ai_player.game_over = true
			GameManager.battle_map.show_text("You win!")
			var reward_text := []
			var battle_rewards := PlayerManager.get_battle_reward()
			for c in battle_rewards:
				PlayerManager.add_card_to_collection(c)
				reward_text.append(str(
					"Congratulations! You receive ", CardDatabase.cards_info[c]["InGameName"]
				))
			
			TransitionScene.transition_to_overworld_scene(
				AreaDatabase.area_ids.STARTING, -1, reward_text
			)
			return
		elif (
			conquered_victory_spaces >= MapSettings.n_progress_bars 
			and GameManager.player_id != p_id
		):
			if GameManager.is_single_player:
				GameManager.ai_player.game_over = true
			
			GameManager.battle_map.show_text("You lose!")
			TransitionScene.transition_to_overworld_scene(
				AreaDatabase.area_ids.STARTING, -1
			)
			return
		
		for b in range(len(GameManager.progress_bars[p_id])):
			if conquered_victory_spaces > b:
				GameManager.progress_bars[p_id][b].value = 100
			else:
				GameManager.progress_bars[p_id][b].value = 0


@rpc("any_peer", "call_local")
func remove_from_cards_in_play(card: CardInPlay) -> void:
	var card_owner_id := card.card_owner_id
	var card_in_play_index := card.card_in_play_index
	for p_id in GameManager.players:
		GameManager.cards_in_play[card_owner_id].remove_at(card_in_play_index)


@rpc("any_peer", "call_local")
func move_to_play_space(
	card_owner_id: int, card_in_play_index: int, new_column: int, new_row: int
) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][card_in_play_index]
	assert(
		!GameManager.ps_column_row[new_column][new_row].card_in_this_play_space, 
		"tried to move to occupied space"
	)
	
	card.current_play_space.card_in_this_play_space = null
	card.column = new_column
	card.row = new_row
	card.current_play_space.card_in_this_play_space = card
	card.set_position_to_play_space()
	card.update_stats()


@rpc("any_peer", "call_local")
func swap_cards(
	card_owner_id_1: int, cip_index_1: int, card_owner_id_2: int, cip_index_2: int
) -> void:
	var card_1: CardInPlay = GameManager.cards_in_play[card_owner_id_1][cip_index_1]
	var card_2: CardInPlay = GameManager.cards_in_play[card_owner_id_2][cip_index_2]
	var new_column_1 := card_2.column
	var new_column_2 := card_1.column
	var new_row_1 := card_2.row
	var new_row_2 := card_1.row
	
	card_1.current_play_space.card_in_this_play_space = null
	card_1.column = new_column_1
	card_1.row = new_row_1
	card_1.current_play_space.card_in_this_play_space = card_1
	card_1.set_position_to_play_space()
	card_1.update_stats()
	
	card_2.current_play_space.card_in_this_play_space = null
	card_2.column = new_column_2
	card_2.row = new_row_2
	card_2.current_play_space.card_in_this_play_space = card_2
	card_2.set_position_to_play_space()
	card_2.update_stats()
	

@rpc("any_peer", "call_local")
func set_hand_card_positions() -> void:
	for p_id in GameManager.players:
		for k in range(len(GameManager.cards_in_hand[p_id])):
			var card: CardInHand = GameManager.cards_in_hand[p_id][k]
			card.set_card_position()


@rpc("any_peer", "call_local")
func draw_card(card_owner_id: int) -> void:
	await GameManager.decks[card_owner_id].draw_card()
	return

@rpc("any_peer", "call_local")
func draw_type_put_rest_bottom(card_owner_id: int, card_type: int) -> void:
	GameManager.decks[card_owner_id].draw_type_put_rest_bottom(card_type)


@rpc("any_peer", "call_local")
func lock_zoom_preview_hand(card_owner_id: int, hand_index: int) -> void:
	var hand_card: CardInHand = GameManager.cards_in_hand[card_owner_id][hand_index]
	GameManager.zoom_preview.preview_hand_card(hand_card, true)


func ask_resolve_spell_agreement() -> void:
	if GameManager.is_single_player:
		GameManager.battle_map.show_resolve_spell_button()
	if !GameManager.is_single_player:
		GameManager.battle_map.show_resolve_spell_button.rpc_id(
			GameManager.opposing_player_id(GameManager.player_id)
		)


@rpc("any_peer", "call_local")
func resolve_spell_agreed() -> void:
	Events.resolve_spell_button_pressed.emit()


@rpc("any_peer", "call_local")
func reset_zoom_preview() -> void:
	GameManager.zoom_preview.reset_zoom_preview()


@rpc("any_peer", "call_local")
func pick_card(player_id: int, option_index: int, card_indices: Array) -> void:
	GameManager.decks[player_id].create_hand_card(card_indices[option_index])
	for c in len(card_indices):
		if c != option_index:
			GameManager.decks[player_id].send_to_discard(card_indices[c])


@rpc("any_peer", "call_local")
func resolve_spell(card_owner_id: int, hand_index: int, column: int, row: int) -> void:
	var card_in_hand: CardInHand = GameManager.cards_in_hand[card_owner_id][hand_index]
	var card: CardInPlay = CardDatabase.get_card_class(card_in_hand.card_index).new()
	card.card_owner_id = card_in_hand.card_owner_id
	@warning_ignore("redundant_await")
	var succesfull_resolve: bool = await card.resolve_spell(column, row)
	TargetSelection.end_selecting()
	
	var h_index = hand_index
	if succesfull_resolve:
		GameManager.resources[card_in_hand.card_owner_id].pay_costs(card_in_hand.costs)
	
	if GameManager.is_single_player:
		BattleSynchronizer.reset_zoom_preview()
		BattleSynchronizer.remove_card_from_hand(card_owner_id, h_index)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			BattleSynchronizer.reset_zoom_preview.rpc_id(p_id)
			BattleSynchronizer.remove_card_from_hand.rpc_id(p_id, card_owner_id, h_index)
	
	GameManager.turn_manager.set_turn_actions_enabled(true)
	

func finish_resolve() -> void:
	await get_tree().process_frame
	Events.hide_instructions.emit()
	GameManager.battle_map.hide_finish_button()
	GameManager.turn_manager.set_turn_actions_enabled(true)
	TargetSelection.end_selecting()


func call_triggered_funcs(trigger: int, triggering_card: CardInPlay) -> void:
	for p_id in GameManager.players:
		for card in GameManager.cards_in_play[p_id]:
			await card.call_triggered_funcs(trigger, triggering_card)


@rpc("any_peer", "call_local")
func refresh_all_units(card_owner_id: int) -> void:
	for c in GameManager.cards_in_play[card_owner_id]:
		c.refresh()
