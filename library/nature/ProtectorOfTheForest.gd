extends CardInPlay

class_name ProtectorOfTheForest


var has_moved: bool = false


func call_triggered_funcs(trigger: int, triggering_card: CardInPlay) -> void:
	if (
		trigger == Collections.triggers.TURN_STARTED 
		and GameManager.turn_manager.turn_owner_id == card_owner_id
	):
		if !has_moved:
			for p_id in GameManager.players:
				MPCardManipulation.change_health.rpc_id(
					p_id, card_owner_id, card_in_play_index, 2, -1
				)
	
		has_moved = false
	elif trigger == Collections.triggers.CARD_MOVED and triggering_card == self:
		has_moved = true
