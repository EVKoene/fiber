extends Node


enum maps {BASE_MAP, BOSS_MAP,}

var map_data: Dictionary = {
	
	maps.BASE_MAP: {
		"Columns": 7,
		"Rows": 5,
		"P2StartSpaces": [
			Vector2(1, 0), Vector2(2, 0), Vector2(3, 0), Vector2(4, 0), Vector2(5, 0), 
			Vector2(1, 1), Vector2(2, 1), Vector2(3, 1), Vector2(4, 1), Vector2(5, 1),
		],
		"P1StartSpaces": [
			Vector2(1, 3), Vector2(2, 3), Vector2(3, 3), Vector2(4, 3), Vector2(5, 3),
			Vector2(1, 4), Vector2(2, 4), Vector2(3, 4), Vector2(4, 4), Vector2(5, 4),
		],
		"ResourceSpaces": [
			Vector2(2, 0), Vector2(3, 0), Vector2(4, 0),
			Vector2(2, 4), Vector2(3, 4), Vector2(4, 4),
			Vector2(0, 0), Vector2(6, 0), Vector2(0, 4), Vector2(6, 4), Vector2(3, 2), 			
		],
		"DrawCardSpaces": [Vector2(0, 2), Vector2(6, 2)]
	},
	
	maps.BOSS_MAP: {
		"Columns": 12,
		"Rows": 8,
		"P2StartSpaces":[
			Vector2(3, 0), Vector2(4, 0), Vector2(5, 0), Vector2(6, 0), Vector2(7, 0), 
			Vector2(8, 0), Vector2(3, 1), Vector2(4, 1), Vector2(5, 1), Vector2(6, 1), 
			Vector2(7, 1), Vector2(8, 1)
		],
		"P1StartSpaces": [
			Vector2(3, 6), Vector2(4, 6), Vector2(5, 6), Vector2(6, 6), Vector2(7, 6), 
			Vector2(8, 6), Vector2(3, 7), Vector2(4, 7), Vector2(5, 7), Vector2(6, 7), 
			Vector2(7, 7), Vector2(8, 7)
		],
		"ResourceSpaces": [
			Vector2(4, 0), Vector2(5, 0), Vector2(6, 0), Vector2(7, 0), Vector2(4, 7), 
			Vector2(5, 7), Vector2(6, 7), Vector2(7, 7), Vector2(0, 0), Vector2(11, 0), 
			Vector2(0, 3), Vector2(11, 4), Vector2(0, 7), Vector2(11, 7)
		],
		"DrawCardSpaces": [Vector2(0, 4), Vector2(11, 3)]
	},
}


func get_play_space_attributes(map: int, play_space: PlaySpace) -> Array:
	var attributes: Array = []
	for v in map_data[map]["P1StartSpaces"]:
		if play_space.column == v.x and play_space.row == v.y:
			attributes.append(Collections.play_space_attributes.P1_START_SPACE)

	for v in map_data[map]["P2StartSpaces"]:
		if play_space.column == v.x and play_space.row == v.y:
			attributes.append(Collections.play_space_attributes.P2_START_SPACE)
	
	for v in map_data[map]["ResourceSpaces"]:
		if play_space.column == v.x and play_space.row == v.y:
			attributes.append(Collections.play_space_attributes.RESOURCE_SPACE)

	for v in map_data[map]["DrawCardSpaces"]:
		if play_space.column == v.x and play_space.row == v.y:
			attributes.append(Collections.play_space_attributes.DRAW_CARD_SPACE)

	return attributes
