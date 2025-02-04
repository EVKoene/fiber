extends Node

enum area_ids {
	START_OF_JOURNEY,
	PASSION_LEVEL_1,
	START_OF_PASSION,
	GROWTH_LEVEL_1,
	START_OF_GROWTH,
	IMAGINATION_LEVEL_1,
	START_OF_IMAGINATION,
	START_OF_LOGIC,
}

var areas := {
	area_ids.START_OF_JOURNEY:
	{
		"AreaName": "Start Of Journey",
		"ScenePath": "res://overworld/areas/StartOfJourney.tscn",
		"TransitionPosition":
		{
			area_ids.START_OF_GROWTH: Vector2(1120, 50),
			area_ids.START_OF_PASSION: Vector2(-289, -245),
			area_ids.START_OF_IMAGINATION: Vector2(-240, 700),
			area_ids.START_OF_LOGIC: Vector2(-410, 0),
		},
		"StartingPosition": Vector2(300, 360)
	},
	area_ids.PASSION_LEVEL_1:
	{
		"AreaName": "Passion Level 1",
		"ScenePath": "res://overworld/areas/PassionLevel1.tscn",
		"TransitionPosition":
		{
			area_ids.START_OF_PASSION: Vector2(290, -670),
		},
		"StartingPosition": Vector2(603, -73)
	},
	area_ids.START_OF_PASSION:
	{
		"AreaName": "Start Of Passion",
		"ScenePath": "res://overworld/areas/StartOfPassion.tscn",
		"TransitionPosition":
		{
			area_ids.PASSION_LEVEL_1: Vector2(1264, 827),
			area_ids.START_OF_JOURNEY: Vector2(1264, 827),
		},
		"StartingPosition": Vector2(86, 134)
	},
	area_ids.GROWTH_LEVEL_1:
	{
		"AreaName": "Growth Level 1",
		"ScenePath": "res://overworld/areas/GrowthLevel1.tscn",
		"TransitionPosition":
		{
			area_ids.START_OF_GROWTH: Vector2(-100, 70),
			area_ids.START_OF_PASSION: Vector2(1080, 70),
		},
		"StartingPosition": Vector2(500, 70)
	},
	area_ids.START_OF_GROWTH:
	{
		"AreaName": "Start Of Growth",
		"ScenePath": "res://overworld/areas/StartOfGrowth.tscn",
		"TransitionPosition":
		{
			area_ids.START_OF_JOURNEY: Vector2(100, 170),
			area_ids.GROWTH_LEVEL_1: Vector2(1300, 170),
		},
		"StartingPosition": Vector2(86, 134)
	},
	area_ids.START_OF_IMAGINATION:
	{
		"AreaName": "Start Of Imagination",
		"ScenePath": "res://overworld/areas/StartOfImagination.tscn",
		"TransitionPosition":
		{
			area_ids.START_OF_JOURNEY: Vector2(-290, 20),
		},
		"StartingPosition": Vector2(86, 134)
	},
	area_ids.IMAGINATION_LEVEL_1:
	{
		"AreaName": "Imagination Level 1",
		"ScenePath": "res://overworld/areas/ImaginationLevel1.tscn",
		"TransitionPosition":
		{
			area_ids.START_OF_JOURNEY: Vector2(-650, 0),
			area_ids.START_OF_IMAGINATION: Vector2(1000, 0),
		},
		"StartingPosition": Vector2(0, 0)
	},
	area_ids.START_OF_LOGIC:
	{
		"AreaName": "Start Of Logic",
		"ScenePath": "res://overworld/areas/StartOfLogic.tscn",
		"TransitionPosition":
		{
			area_ids.START_OF_JOURNEY: Vector2(-603, -73),
		},
		"StartingPosition": Vector2(603, -73)
	},
}


func get_area_scene(area_id: int) -> String:
	return areas[area_id]["ScenePath"]
