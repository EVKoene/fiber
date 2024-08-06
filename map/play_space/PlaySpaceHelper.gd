extends Node


# Called when the node enters the scene tree for the first time.
func play_spaces_in_range(
	card_owner_id: int, range_to_check: int, ignore_obstacles := true
) -> Array:
	var spaces: Array = []
	for ps in GameManager.play_spaces:
		for c in GameManager.cards_in_play[card_owner_id]:
			if ps in c.spaces_in_range(range_to_check, ignore_obstacles):
				spaces.append(ps)
				break

	return spaces
