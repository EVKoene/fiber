extends Node

var burn_scene := preload("res://styling/assets/fire/BurnAnimation.tscn")
var hailstorm_scene := preload("res://styling/assets/hailstorm/HailAnimation.tscn")

@rpc("any_peer", "call_local")
func animate_attack(card_owner_id: int, card_in_play_index: int, direction: int) -> void:
	var card: CardInPlay = GameManager.cards_in_play[card_owner_id][card_in_play_index]

	if not card:
		return

	if card.attack_tween and card.attack_tween.is_running():
		card.attack_tween.kill()

	var original_pos: Vector2 = card.position
	var offset := Vector2.ZERO

	match direction:
		Collections.directions.UP:
			offset = Vector2(0, -MapSettings.play_space_size.y / 2)
		Collections.directions.DOWN:
			offset = Vector2(0, MapSettings.play_space_size.y / 2)
		Collections.directions.RIGHT:
			offset = Vector2(MapSettings.play_space_size.x / 2, 0)
		Collections.directions.LEFT:
			offset = Vector2(-MapSettings.play_space_size.x / 2, 0)

	card.attack_tween = create_tween()
	
	card.attack_tween.set_trans(Tween.TRANS_BACK)
	card.attack_tween.set_ease(Tween.EASE_OUT)

	card.attack_tween.tween_property(card, "position", original_pos + offset, 0.125)
	card.attack_tween.tween_property(card, "position", original_pos, 0.125)


@rpc("any_peer", "call_local")
func play_burn_animation(column: int, row: int) -> void:
	var burn: Node2D = burn_scene.instantiate()
	burn.position.x = MapSettings.get_column_start_x(column) + (MapSettings.play_space_size.x / 4)
	burn.position.y = MapSettings.get_row_start_y(row) + (MapSettings.play_space_size.y / 4)
	GameManager.battle_map.add_child(burn)


@rpc("any_peer", "call_local")
func play_hailstorm_animation(play_space: PlaySpace) -> void:
	var hailstorm: Node2D = hailstorm_scene.instantiate()
	hailstorm.position.x = play_space.position.x
	hailstorm.position.y = play_space.position.y
	GameManager.battle_map.add_child(hailstorm)


@rpc("any_peer", "call_local")
func unhighlight_all_spaces() -> void:
	for ps in GameManager.play_spaces:
		ps.set_border()
