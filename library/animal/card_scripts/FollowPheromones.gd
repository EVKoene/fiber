extends CardInPlay


class_name FollowPheromones

func resolve_spell(_c_column: int, _c_row) -> bool:
	MultiPlayerManager.ask_resolve_spell_agreement()
	await Events.resolve_spell_button_pressed
	
	for i in range(2):
		MultiPlayerManager.draw_type_put_rest_bottom.rpc_id(
			GameManager.p1_id, card_owner_id, Collections.card_types.UNIT
		)
		await GameManager.battle_map.get_tree().create_timer(0.25).timeout
	
	await GameManager.battle_map.get_tree().create_timer(0.25).timeout
	
	return true


func resolve_spell_for_ai() -> void:
	resolve_spell(-1, -1)
