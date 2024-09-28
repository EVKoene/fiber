extends CardInPlay

class_name FlowAccelerator

var last_space: PlaySpace


func enter_battle() -> void:
	last_space = current_play_space


func call_triggered_funcs(trigger: int, triggering_card: CardInPlay) -> void:
	if trigger == Collections.triggers.CARD_MOVED and triggering_card == self:
		var spaces_moved = last_space.distance_to_play_space(current_play_space, true)
		if GameManager.is_single_player:
			CardManipulation.change_max_attack(card_owner_id, card_in_play_index, spaces_moved, 2)
			CardManipulation.change_health(card_owner_id, card_in_play_index, spaces_moved, 2)
			CardManipulation.update_stats(card_owner_id, card_in_play_index)
		if !GameManager.is_single_player:
			for p_id in GameManager.players:
				CardManipulation.change_max_attack.rpc_id(
					p_id, card_owner_id, card_in_play_index, spaces_moved, 2
				)
				CardManipulation.change_health.rpc_id(
					p_id, card_owner_id, card_in_play_index, spaces_moved, 2
				)
				CardManipulation.update_stats.rpc_id(p_id, card_owner_id, card_in_play_index)
			
		last_space = current_play_space
