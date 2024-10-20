extends Node


# Called when the node enters the scene tree for the first time.
func spaces_in_range(
	spaces_to_check: Array, card_owner_id: int, range_to_check: int, ignore_obstacles := true
) -> Array:
	var spaces := []
	for ps in spaces_to_check:
		if is_space_in_range(ps, card_owner_id, range_to_check, ignore_obstacles):
			spaces.append(ps)

	return spaces


func is_space_in_range(
	play_space: PlaySpace, card_owner_id: int, range_to_check: int, ignore_obstacles := true
) -> bool:
	for card in GameManager.lobby.cards_in_play[card_owner_id]:
		if card.current_play_space.distance_to_play_space(
			play_space, ignore_obstacles
		) <= range_to_check:
			return true
	return false
