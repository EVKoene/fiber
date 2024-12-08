extends Node


enum area_ids { STARTING, MINIBOSS }

var areas := {
	area_ids.STARTING: {
		"AreaName": "Starting",
		"ScenePath": "res://overworld/areas/StartingArea.tscn",
		"TransitionPosition": {
			area_ids.MINIBOSS: Vector2(-710, -426),
		},
		"StartingPosition": Vector2(286, 150)
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
