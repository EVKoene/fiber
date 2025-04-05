extends CardInPlay

class_name ZoloiCharger

var charged := false


func call_triggered_funcs(trigger: int, _triggering_card: Card) -> void:
	if (
		trigger != Collections.triggers.TURN_STARTED
		or GameManager.turn_manager.turn_owner_id != card_owner_id
	):
		return

	charged = true
	if column == 0 or column == MapSettings.n_columns - 1:
		charged = false
	else:
		for ps in [
			GameManager.ps_column_row[column - 1][row], GameManager.ps_column_row[column + 1][row]
		]:
			if !ps.card_in_this_play_space:
				charged = false
				break
			if ps.card_in_this_play_space.card_owner_id != card_owner_id:
				charged = false
				break

	if charged:
		CardManipulation.change_battle_stat(
			Collections.stats.MAX_ATTACK, card_owner_id, card_in_play_index, 3, 2
		)
		CardManipulation.change_battle_stat(
			Collections.stats.MOVEMENT, card_owner_id, card_in_play_index, 1, 2
		)
	
	return


func attack_card(target_card: CardInPlay) -> void:
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.ATTACK, self)
	if GameManager.is_single_player:
		BattleAnimation.animate_attack(
			card_owner_id,
			card_in_play_index,
			target_card.current_play_space.direction_from_play_space(current_play_space)
		)
	if !GameManager.is_single_player:
		for p_id in [GameManager.p1_id, GameManager.p2_id]:
			BattleAnimation.animate_attack.rpc_id(
				p_id,
				card_owner_id,
				card_in_play_index,
				target_card.current_play_space.direction_from_play_space(current_play_space)
			)

	var adjacent_cards: Array = CardHelper.cards_in_range_of_card(
		target_card, 1, TargetSelection.target_restrictions.OWN_UNITS
	)
	deal_damage_to_card(target_card, int(randi_range(min_attack, max_attack)))

	if charged:
		for c in adjacent_cards:
			c.resolve_damage(1)
	BattleSynchronizer.call_triggered_funcs(Collections.triggers.ATTACK_FINISHED, self)
