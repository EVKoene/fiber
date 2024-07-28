extends Node


func frenzy(
	card: CardInPlay, trigger: int, triggering_card: CardInPlay, _func_arguments: Dictionary
) -> void:
	if (
		trigger == Collections.triggers.TURN_STARTED 
		and GameManager.turn_manager.turn_owner_id == card.card_owner_id
	):
		var units_to_attack: Array = CardHelper.closest_enemy_units(card)
		if len(units_to_attack) > 0:
			var target_unit: CardInPlay = units_to_attack.pick_random()
			if card.current_play_space.distance_to_play_space(
				target_unit.current_play_space, false
			) == 1:
				card.attack_card(target_unit)
				card.exhaust()
			else:
				var path_to_take: PlaySpacePath = card.current_play_space.path_to_closest_movable_space(
					target_unit.current_play_space, card.battle_stats.movement, card.move_through_units
				)
				await card.move_over_path(path_to_take)
				if target_unit.current_play_space in card.current_play_space.adjacent_play_spaces():
					card.attack_card(target_unit)
				card.exhaust()
		else:
			card.exhaust()
		await get_tree().create_timer(0.25).timeout


func damage_self(
	card: CardInPlay, trigger: int, triggering_card: CardInPlay, func_arguments: Dictionary
) -> void:
	if trigger == func_arguments["Trigger"] and card == triggering_card:
		card.resolve_damage(func_arguments["Damage"])
