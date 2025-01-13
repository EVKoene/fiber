extends Node


enum area_ids {
	 START_OF_JOURNEY, START_OF_GROWTH, START_OF_PASSION, START_OF_IMAGINATION, 
	START_OF_LOGIC, 
}

var areas := {
	area_ids.START_OF_JOURNEY: {
		"AreaName": "Start Of Journey",
		"ScenePath": "res://overworld/areas/StartOfJourney.tscn",
		"TransitionPosition": {
			area_ids.START_OF_GROWTH: Vector2(1100, 0),
			area_ids.START_OF_PASSION: Vector2(-289, -245),
			area_ids.START_OF_IMAGINATION: Vector2(-240, 700),
			area_ids.START_OF_LOGIC: Vector2(-410, 0),
		},
		"StartingPosition": Vector2(300, 360)
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
	
	area_ids.START_OF_IMAGINATION: {
		"AreaName": "Start Of Imagination",
		"ScenePath": "res://overworld/areas/StartOfImagination.tscn",
		"TransitionPosition": {
			area_ids.START_OF_JOURNEY: Vector2(-290, 20),
		},
		"StartingPosition": Vector2(86, 134)
	},
	
	area_ids.START_OF_LOGIC: {
		"AreaName": "Start Of Logic",
		"ScenePath": "res://overworld/areas/StartOfLogic.tscn",
		"TransitionPosition": {
			area_ids.START_OF_JOURNEY: Vector2(-603, -73),
		},
		"StartingPosition": Vector2(603, -73)
	},
}


func get_area_scene(area_id: int) -> String:
	return areas[area_id]["ScenePath"]
