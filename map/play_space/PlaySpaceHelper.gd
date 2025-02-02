extends Node


func is_space_in_range(
	play_space: PlaySpace, card_owner_id: int, range_to_check: int, ignore_obstacles := true
) -> bool:
	for card in GameManager.cards_in_play[card_owner_id]:
		if (
			card.current_play_space.distance_to_play_space(play_space, ignore_obstacles)
			<= range_to_check
		):
			return true
	return false


func spaces_in_range(range_to_check: int, player_id: int) -> Array:
	var spaces := []
	for c in GameManager.cards_in_play[player_id]:
		for ps in c.spaces_in_range(range_to_check):
			if ps not in spaces:
				spaces.append(ps)

	return spaces
