extends CardInPlay

class_name FlowAccelerator

var last_space: PlaySpace


func enter_battle() -> void:
	last_space = current_play_space


func call_triggered_funcs(trigger: int, triggering_card: CardInPlay) -> void:
	if trigger == Collections.triggers.CARD_MOVED and triggering_card == self:
		var spaces_moved = last_space.distance_to_play_space(current_play_space, true)
		for p_id in GameManager.players:
			MPCardManipulation.change_max_attack.rpc_id(
				p_id, card_owner_id, card_in_play_index, spaces_moved, 2
			)
			MPCardManipulation.change_health.rpc_id(
				p_id, card_owner_id, card_in_play_index, spaces_moved, 2
			)
			MPCardManipulation.update_stats.rpc_id(p_id, card_owner_id, card_in_play_index)
		
		last_space = current_play_space
