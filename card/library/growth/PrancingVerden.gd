extends CardInPlay

class_name PrancingVerden


func _init():
	move_through_units = true


func move_over_path(path: PlaySpacePath) -> void:
	GameManager.turn_manager.set_turn_actions_enabled(false)
	TargetSelection.clear_arrows()
	if path.path_length > 0:
		for s in range(path.path_length):
			# We ignore the first playspace in path because it's the space the card is in. We
			# also ignore spaces the cards move trough. TODO: Animate moving through them.
			if s == 0:
				continue
			elif path.path_spaces[s].card_in_this_play_space and move_through_units:
				await get_tree().create_timer(0.25).timeout
				# We increase and decrease the z index to make sure the card will move over the card
				# it passes through
				z_index += 50
				position.x = path.path_spaces[s].position.x + MapSettings.play_space_size.x * 0.05
				position.y = path.path_spaces[s].position.y + MapSettings.play_space_size.y * 0.05
				if path.path_spaces[s].card_in_this_play_space.card_owner_id == card_owner_id:
					var card: CardInPlay = path.path_spaces[s].card_in_this_play_space
					for p_id in GameManager.players:
						CardManipulation.change_battle_stat(
							Collections.stats.MOVEMENT,
							card.card_owner_id,
							card.card_in_play_index,
							2,
							1
						)
						CardManipulation.change_battle_stat(
							Collections.stats.MIN_ATTACK,
							card.card_owner_id,
							card.card_in_play_index,
							1,
							1
						)
				z_index -= 50
			else:
				await get_tree().create_timer(0.25).timeout
				move_to_play_space(path.path_spaces[s].column, path.path_spaces[s].row)
