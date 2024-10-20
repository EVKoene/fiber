extends CardInPlay


class_name FelosExpeditionist


func attack_card(target_card: CardInPlay) -> void:
	if GameManager.is_single_player:
		BattleAnimation.animate_attack(
			card_owner_id, card_in_play_index, 
			target_card.current_play_space.direction_from_play_space(current_play_space)
		)
		BattleManager.draw_card(card_owner_id)
	if !GameManager.is_single_player:
		for p_id in [GameManager.p1_id, GameManager.p2_id]:
			BattleAnimation.animate_attack.rpc_id(
				p_id, card_owner_id, card_in_play_index, 
				target_card.current_play_space.direction_from_play_space(current_play_space)
			)
		BattleManager.draw_card.rpc_id(GameManager.p1_id, card_owner_id)
	
	deal_damage_to_card(target_card, int(randf_range(min_attack, max_attack)))
	
