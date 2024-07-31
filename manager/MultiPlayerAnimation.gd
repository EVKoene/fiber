extends Node


var burn_scene := preload("res://styling/assets/fire/BurnAnimation.tscn")

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
func play_burn_animation(column: int, row: int) -> void:
	var burn: Node2D = burn_scene.instantiate()
	burn.position.x = MapSettings.get_column_start_x(column) + (MapSettings.play_space_size.x / 4)
	burn.position.y = MapSettings.get_row_start_y(row) + (MapSettings.play_space_size.y / 4)
	GameManager.add_child(burn)


@rpc("any_peer", "call_local")
func highlight_card(card_owner_id: int, cip_index: int):
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][cip_index]
	card.get_theme_stylebox("panel").border_color = Styling.gold_color


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
func unhighlight_all_spaces() -> void:
	for ps in GameManager.play_spaces:
		ps.set_border()
