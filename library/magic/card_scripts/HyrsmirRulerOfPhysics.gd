extends CardInPlay

class_name HyrsmirRulerOfPhysics

var swapping_cards: bool = false


func call_triggered_funcs(trigger: int, _triggering_card: CardInPlay) -> void:
	if (
		trigger == Collections.triggers.TURN_STARTED 
		and GameManager.lobby.turn_manager.turn_owner_id == card_owner_id
		and len(GameManager.lobby.cards_in_play[card_owner_id]) > 1
	):
		GameManager.lobby.turn_manager.set_turn_actions_enabled(false)
		Events.show_instructions.emit("Swap any number of cards and press finish")
		swapping_cards = true
		GameManager.lobby.battle_map.show_finish_button()
		while swapping_cards:
			TargetSelection.select_targets(
				2, TargetSelection.target_restrictions.OWN_UNITS, self, true, -1, true
			)
			await TargetSelection.target_selection_finished
			assert(len(TargetSelection.selected_targets) in [0, 1, 2], "Error selecting targets for
			Hyrsmir's ability. Expected either 0 or 2 targets.")
			if len(TargetSelection.selected_targets) == 2:
				TargetSelection.selected_targets[0].swap_with_card(
					TargetSelection.selected_targets[1].card_owner_id, 
					TargetSelection.selected_targets[1].card_in_play_index, 
				)
				for c in TargetSelection.selected_targets:
					c.set_border_to_faction()
				TargetSelection.clear_selections()


func finish_swapping() -> void:
	swapping_cards = false
	TargetSelection.target_selection_finished.emit()
	BattleManager.finish_resolve()


func _connect_signals() -> void:
	Events.finish_button_pressed.connect(finish_swapping, 8)
