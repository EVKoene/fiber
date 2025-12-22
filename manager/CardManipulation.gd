extends Node


@onready var card_scene: PackedScene = preload("res://card/card_classes/Card.tscn")


@rpc("any_peer", "call_local")
func destroy(card_owner_id: int, cip_index: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.current_play_space.card_in_this_play_space = null
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.CARD_DESTROYED, card)
	card.call_deferred("remove_from_cards_in_play")
	card.call_deferred("queue_free")
	if card.is_boss:
		if card.card_owner_id == GameManager.player_id:
			BattleSynchronizer.finish_with_victory()
		else:
			BattleSynchronizer.finish_with_defeat()


@rpc("any_peer", "call_local")
func update_stats(card_owner_id: int, cip_index: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.update_stats()


@rpc("any_peer", "call_local")
func change_battle_stat(
	battle_stat: int, card_owner_id: int, cip_index: int, value: int, duration: int
) -> void:
	if GameManager.is_single_player:
		var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
		card.battle_stats.change_battle_stat(battle_stat, value, duration)
	if !GameManager.is_single_player:
		for p_id in GameManager.players:
			MPCardManipulation.change_battle_stat.rpc_id(
				p_id, battle_stat, card_owner_id, cip_index, value, duration
			)


@rpc("any_peer", "call_local")
func hide_all_borders() -> void:
	for p_id in GameManager.players:
		for c in GameManager.cards_in_play[p_id]:
			c.hide_border()


@rpc("any_peer", "call_local")
func hide_border(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.hide_border()


func show_card_dummy(card_index: int, ps: PlaySpace) -> Card:
	var card: Card = card_scene.instantiate()
	card.card_class = Collections.card_classes.CARD_IN_PLAY
	card.card_index = card_index
	card.load_card_properties()
	GameManager.battle_map.add_child(card)
	
	card.position.x = MapSettings.get_column_start_x(ps.column) + MapSettings.play_space_size.x * 0.05
	card.position.y = MapSettings.get_row_start_y(ps.row) + MapSettings.play_space_size.y * 0.05
	card.z_index = 100
	
	card.scale *= MapSettings.card_in_play_size / card.size
	card.modulate = Color(1, 1, 1, 0.25)
	
	return card
