extends CardInPlay


class_name FireGolem


func _init():
	abilities = [{
		"FuncName": "burn",
		"FuncText": "Burn",
		"AbilityCosts": Costs.new(0, 0, 0, 0),
	}]


func burn() -> bool:
	for ps in spaces_in_range(2, true):
		if ps != current_play_space:
			for p_id in GameManager.players:
				BattleAnimation.play_burn_animation.rpc_id(p_id, ps.column, ps.row)
		if ps.card_in_this_play_space:
			if ps.card_in_this_play_space.card_owner_id != card_owner_id:
				ps.card_in_this_play_space.resolve_damage(battle_stats.min_attack)

	exhaust()
	return true
