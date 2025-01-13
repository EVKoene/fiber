extends Node


func is_space_in_range(
	play_space: PlaySpace, card_owner_id: int, range_to_check: int, ignore_obstacles := true
) -> bool:
	for card in GameManager.cards_in_play[card_owner_id]:
		if card.current_play_space.distance_to_play_space(
			play_space, ignore_obstacles
		) <= range_to_check:
			return true
	return false
