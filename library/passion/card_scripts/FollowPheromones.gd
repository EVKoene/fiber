extends CardInPlay


class_name FollowPheromones

func resolve_spell(_c_column: int, _c_row) -> bool:
	for i in range(2):
		if GameManager.is_single_player:
			BattleSynchronizer.draw_type_put_rest_bottom(card_owner_id, Collections.card_types.UNIT)
		if !GameManager.is_single_player:
			BattleSynchronizer.draw_type_put_rest_bottom.rpc_id(
				GameManager.p1_id, card_owner_id, Collections.card_types.UNIT
			)
		await GameManager.battle_map.get_tree().create_timer(0.25).timeout
	
	await GameManager.battle_map.get_tree().create_timer(0.25).timeout
	
	BattleSynchronizer.finish_resolve()
	return true


func resolve_spell_for_ai() -> void:
	resolve_spell(-1, -1)
	Events.spell_resolved_for_ai.emit()
	BattleSynchronizer.finish_resolve()


func is_spell_to_play_now() -> bool:
	for c in GameManager.cards_in_hand[GameManager.ai_player_id]:
		if GameManager.resources[GameManager.ai_player_id].can_pay_costs(c.costs):
			if c.costs.total() >= costs.total:
				return true
	
	return false
