extends Node


enum area_ids { START_OF_JOURNEY, START_OF_GROWTH }

var areas := {
	area_ids.START_OF_JOURNEY: {
		"AreaName": "StartOfJourney",
		"ScenePath": "res://overworld/areas/StartOfJourney.tscn",
		"TransitionPosition": {
			area_ids.START_OF_GROWTH: Vector2(497, 88),
		},
		"StartingPosition": Vector2(286, 150)
	},
	area_ids.START_OF_GROWTH: {
		"AreaName": "StartOfGrowth",
		"ScenePath": "res://overworld/areas/MiniBoss.tscn",
		"TransitionPosition": {
			area_ids.START_OF_JOURNEY: Vector2(86, 134),
		},
		"StartingPosition": Vector2(86, 134)
	},
}


func get_area_scene(area_id: int) -> String:
	return areas[area_id]["ScenePath"]
