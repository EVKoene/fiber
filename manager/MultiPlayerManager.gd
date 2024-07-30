extends Node

"""
In this script you will find functions to synchronize the battlefield between players. If a player
creates or moves a card, the specified functions should be called here by both players with the
necessary information. This means we hardly use the multiplayer spawner or synchronizer, as both
client and server will create objects and execute functionality seperately. 
"""

@onready var card_in_play_scene: PackedScene = preload("res://card/CardInPlay.tscn")
@onready var card_in_hand_scene: PackedScene = preload("res://card/CardInHand.tscn")


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
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	var damage_number = Label.new()
	card.add_child(damage_number)
	damage_number.scale *= MapSettings.card_in_play_size * 0.9 / damage_number.size 
	damage_number.text = str(value)
	damage_number.label_settings = LabelSettings.new()
	damage_number.label_settings.font_size = 100
	damage_number.label_settings.font_color = Color("f41700")
	await get_tree().create_timer(0.5).timeout
	damage_number.queue_free()
	
	if value > 0:
		card.shake()
	
	card.battle_stats.change_health(-value, -1)
	card.update_stats()
	if card.health <= 0:
		card.destroy()


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
	set_progress_bars()


@rpc("any_peer", "call_local")
func create_fabrication(
	card_owner_id: int, column: int, row: int, ingame_name: String, max_attack: int, min_attack: int, 
	health: int, movement: int, triggered_funcs: Array, img_path: String, factions: Array,
	costs: Dictionary, 
) -> void:
	var fabrication = card_in_play_scene.instantiate()
	fabrication.battle_stats = BattleStats.new(
		max_attack, min_attack, health, movement, fabrication
	)
	fabrication.factions = factions
	fabrication.ingame_name = ingame_name
	fabrication.card_owner_id = card_owner_id
	fabrication.column = column
	fabrication.row = row
	fabrication.triggered_funcs = triggered_funcs
	fabrication.img_path = img_path
	fabrication.fabrication = true
	fabrication.costs = Costs.new(
			costs[Collections.factions.ANIMAL],
			costs[Collections.factions.MAGIC],
			costs[Collections.factions.NATURE],
			costs[Collections.factions.ROBOT],
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
func set_conquered_by(player_id: int, column: int, row: int) -> void:
	var play_space = GameManager.ps_column_row[column][row]
	play_space.conquered_by = player_id
	match player_id:
		GameManager.p1_id:
			play_space.get_theme_stylebox("panel").border_color = Styling.p1_color
		GameManager.p2_id:
			play_space.get_theme_stylebox("panel").border_color = Styling.p2_color


@rpc("any_peer", "call_local")
func set_resources(
	resource_owner_id: int, gold: int, animal: int, magic: int, nature: int, robot: int
) -> void:
	GameManager.resource_bars[resource_owner_id].set_resources_labels(
		gold, animal, magic, nature, robot
	)


@rpc("any_peer", "call_local")
func set_progress_bars() -> void:
	for p_id in [GameManager.p1_id, GameManager.p2_id]:
		var conquered_resource_spaces := 0
		for s in GameManager.resource_spaces:
			if !s.conquered_by:
				continue
			if s.conquered_by == p_id:
				conquered_resource_spaces += 1
		
		if (
			conquered_resource_spaces > MapSettings.n_progress_bars 
			and GameManager.player_id == p_id
		):
			GameManager.battle_map.show_text("You win!")
			get_tree().quit()
		elif (
			conquered_resource_spaces > MapSettings.n_progress_bars 
			and GameManager.player_id != p_id
		):
			GameManager.battle_map.show_text("You lose!")
			get_tree().quit()
		
		for b in range(len(GameManager.progress_bars[p_id])):
			if conquered_resource_spaces > b:
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
func animate_attack(card_owner_id: int, card_in_play_index: int, direction: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][card_in_play_index]
	match direction:
		Collections.directions.UP:
			card.position.y -= MapSettings.play_space_size.y / 2
			await get_tree().create_timer(0.25).timeout
			card.position.y += MapSettings.play_space_size.y / 2
		Collections.directions.DOWN:
			card.position.y += MapSettings.play_space_size.y / 2
			await get_tree().create_timer(0.25).timeout
			card.position.y -= MapSettings.play_space_size.y / 2
		Collections.directions.RIGHT:
			card.position.x += MapSettings.play_space_size.x / 2
			await get_tree().create_timer(0.25).timeout
			card.position.x -= MapSettings.play_space_size.x / 2
		Collections.directions.LEFT:
			card.position.x -= MapSettings.play_space_size.x / 2
			await get_tree().create_timer(0.25).timeout
			card.position.x += MapSettings.play_space_size.x / 2


@rpc("any_peer", "call_local")
func highlight_card(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.get_theme_stylebox("panel").border_color = Styling.gold_color


@rpc("any_peer", "call_local")
func set_hand_card_positions() -> void:
	for p in GameManager.cards_in_hand:
		for k in range(len(GameManager.cards_in_hand[p])):
			var card: CardInHand = GameManager.cards_in_hand[p][k]
			card.set_card_position()


@rpc("any_peer", "call_local")
func set_all_borders_to_faction() -> void:
	for p_id in GameManager.players:
		for c in GameManager.cards_in_play[p_id]:
			c.set_border_to_faction()


@rpc("any_peer", "call_local")
func set_border_to_faction(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.set_border_to_faction()


@rpc("any_peer", "call_local")
func draw_card(card_owner_id: int) -> void:
	GameManager.decks[card_owner_id].draw_card()


@rpc("any_peer", "call_local")
func draw_type_put_rest_bottom(card_owner_id: int, card_type: int) -> void:
	GameManager.decks[card_owner_id].draw_type_put_rest_bottom(card_type)


@rpc("any_peer", "call_local")
func lock_zoom_preview_hand(card_owner_id: int, hand_index: int) -> void:
	var hand_card: CardInHand = GameManager.cards_in_hand[card_owner_id][hand_index]
	GameManager.zoom_preview.lock_zoom_preview_hand(hand_card)


func ask_resolve_spell_agreement() -> void:
	GameManager.battle_map.show_resolve_spell_button.rpc_id(
		GameManager.opposing_player_id(GameManager.player_id)
	)


@rpc("any_peer", "call_local")
func resolve_spell_agreed() -> void:
	Events.resolve_spell_button_pressed.emit()


@rpc("any_peer", "call_local")
func reset_zoom_preview() -> void:
	GameManager.zoom_preview.reset_zoom_preview()
