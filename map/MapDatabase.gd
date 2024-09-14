extends Node


enum maps {BASE_MAP, BOSS_MAP,}

var map_data: Dictionary = {
	
	maps.BASE_MAP: {
		"SpacesToWin": 8,
		"Columns": 7,
		"Rows": 5,
		"P1Territory": [Vector2(3, 3), Vector2(3, 4), Vector2(2, 4), Vector2(5, 4)],
		"P2Territory": [Vector2(3, 0), Vector2(2, 0), Vector2(5, 0), Vector2(3, 1)],
		"ResourceSpaces": [
			Vector2(0, 0), Vector2(3, 0), Vector2(6, 0),
			Vector2(0, 2), Vector2(2, 2), Vector2(3, 2), Vector2(4, 2), Vector2(6, 2),
			Vector2(0, 4), Vector2(3, 4), Vector2(6, 4),
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
			attributes.append(Collections.play_space_attributes.RESOURCE_SPACE)

	return attributes
