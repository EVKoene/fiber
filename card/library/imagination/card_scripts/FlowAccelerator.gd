extends CardInPlay

class_name FlowAccelerator

var last_space: PlaySpace


func enter_battle() -> void:
	last_space = current_play_space


func call_triggered_funcs(trigger: int, triggering_card: Card) -> void:
	if trigger == Collections.triggers.CARD_MOVED and triggering_card == self:
		var spaces_moved = last_space.distance_to_play_space(current_play_space, true)
		CardManipulation.change_battle_stat(
			Collections.stats.MAX_ATTACK, card_owner_id, card_in_play_index, spaces_moved, 2
		)
		CardManipulation.change_battle_stat(
			Collections.stats.HEALTH, card_owner_id, card_in_play_index, spaces_moved, 2
		)
	
		last_space = current_play_space
	
	return
