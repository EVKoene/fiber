extends Node


enum area_ids { START_OF_JOURNEY, START_OF_GROWTH, START_OF_PASSION }

var areas := {
	area_ids.START_OF_JOURNEY: {
		"AreaName": "Start Of Journey",
		"ScenePath": "res://overworld/areas/StartOfJourney.tscn",
		"TransitionPosition": {
			area_ids.START_OF_GROWTH: Vector2(497, 88),
			area_ids.START_OF_PASSION: Vector2(220, -99)
		},
		"StartingPosition": Vector2(286, 150)
	},
	area_ids.START_OF_GROWTH: {
		"AreaName": "Start Of Growth",
		"ScenePath": "res://overworld/areas/StartOfGrowth.tscn",
		"TransitionPosition": {
			area_ids.START_OF_JOURNEY: Vector2(86, 134),
		},
		"StartingPosition": Vector2(86, 134)
	},
	area_ids.START_OF_PASSION: {
		"AreaName": "Start Of Passion",
		"ScenePath": "res://overworld/areas/StartOfPassion.tscn",
		"TransitionPosition": {
			area_ids.START_OF_JOURNEY: Vector2(1264, 827),
		},
		"StartingPosition": Vector2(86, 134)
	},
}


func get_area_scene(area_id: int) -> String:
	return areas[area_id]["ScenePath"]
