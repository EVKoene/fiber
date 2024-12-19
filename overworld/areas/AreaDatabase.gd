extends Node


enum area_ids { START_OF_JOURNEY, STARTING, MINIBOSS }

var areas := {
	area_ids.START_OF_JOURNEY: {
		"AreaName": "StartOfJourney",
		"ScenePath": "res://overworld/areas/StartOfJourney.tscn",
		"TransitionPosition": {
			area_ids.MINIBOSS: Vector2(-710, -426),
		},
		"StartingPosition": Vector2(286, 150)
	},
	area_ids.STARTING: {
		"AreaName": "Starting",
		"ScenePath": "res://overworld/areas/StartingArea.tscn",
		"StartingPosition": Vector2(346, 118)
	},
	area_ids.MINIBOSS: {
		"AreaName": "Starting",
		"ScenePath": "res://overworld/areas/MiniBoss.tscn",
		"TransitionPosition": {
			area_ids.STARTING: Vector2(1089, 225),
		},
		"StartingPosition": Vector2(1089, 225)
	},
}


func get_area_scene(area_id: int) -> String:
	return areas[area_id]["ScenePath"]
