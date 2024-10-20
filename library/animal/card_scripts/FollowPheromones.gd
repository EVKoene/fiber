extends CardInPlay


class_name FollowPheromones

func resolve_spell(_c_column: int, _c_row) -> bool:
	for i in range(2):
		if GameManager.lobby.is_single_player:
			BattleManager.draw_type_put_rest_bottom(card_owner_id, Collections.card_types.UNIT)
		if !GameManager.lobby.is_single_player:
			BattleManager.draw_type_put_rest_bottom.rpc_id(
				GameManager.lobby.p1_id, card_owner_id, Collections.card_types.UNIT
			)
		await GameManager.lobby.battle_map.get_tree().create_timer(0.25).timeout
	
	await GameManager.lobby.battle_map.get_tree().create_timer(0.25).timeout
	
	BattleManager.finish_resolve()
	return true


func resolve_spell_for_ai() -> void:
	resolve_spell(-1, -1)
	Events.spell_resolved_for_ai.emit()
	BattleManager.finish_resolve()
