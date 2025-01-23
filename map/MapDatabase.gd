extends Node


enum maps {BASE_MAP, FIRST_ITERATION_MAP, BOSS_MAP,}

var map_data: Dictionary = {
	
	maps.BASE_MAP: {
		"SpacesToWin": 6,
		"Columns": 9,
		"Rows": 7,
		"P1StartingConqueredSpaces": [Vector2(4, 6)],
		"P2StartingConqueredSpaces": [Vector2(4, 0)],
		"P1Territory": [Vector2(4, 6), Vector2(3, 6), Vector2(5, 6), Vector2(4, 5)],
		"P2Territory": [Vector2(4, 0), Vector2(3, 0), Vector2(5, 0), Vector2(4, 1)],
		"ResourceSpaces": [
			Vector2(0, 1), Vector2(8, 1),
			Vector2(2, 2), Vector2(6, 2),
			Vector2(0,3), Vector2(4, 3), Vector2(8, 3),
			Vector2(2, 4), Vector2(6, 4),
			Vector2(0, 5), Vector2(8, 5),
		],
	},
	
	maps.FIRST_ITERATION_MAP: {
		"SpacesToWin": 4,
		"Columns": 7,
		"Rows": 5,
		"P1StartingConqueredSpaces": [Vector2(3, 4)],
		"P2StartingConqueredSpaces": [Vector2(3, 0)],
		"P1Territory": [Vector2(3, 3), Vector2(3, 4), Vector2(2, 4), Vector2(4, 4)],
		"P2Territory": [Vector2(3, 0), Vector2(2, 0), Vector2(4, 0), Vector2(3, 1)],
		"ResourceSpaces": [
			Vector2(3, 0),
			Vector2(1, 1), Vector2(5, 1),
			Vector2(0, 2), Vector2(3, 2), Vector2(6, 2),
			Vector2(1, 3), Vector2(5, 3),
			Vector2(3, 4),
		],
	},
	
	maps.BOSS_MAP: {
		"Columns": 12,
		"Rows": 8,
		"ResourceSpaces": [
			Vector2(4, 0), Vector2(5, 0), Vector2(6, 0), Vector2(7, 0), Vector2(4, 7), 
			Vector2(5, 7), Vector2(6, 7), Vector2(7, 7), Vector2(0, 0), Vector2(11, 0), 
			Vector2(0, 3), Vector2(11, 4), Vector2(0, 7), Vector2(11, 7)
		],
	},
}


func get_play_space_attributes(map: int, play_space: PlaySpace) -> Array:
	var attributes: Array = []
	
	for v in map_data[map]["ResourceSpaces"]:
		if play_space.column == v.x and play_space.row == v.y:
			attributes.append(Collections.play_space_attributes.VICTORY_SPACE)

	return attributes
