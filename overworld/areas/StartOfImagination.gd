extends OverworldArea


func setup_npcs() -> void:
	$StudentDal.setup_npc(NPCDatabase.npcs.STUDENT_DAL, Collections.directions.RIGHT)
	$StudentKala.setup_npc(NPCDatabase.npcs.STUDENT_KALA, Collections.directions.UP)
	$StudentMac.setup_npc(NPCDatabase.npcs.STUDENT_MAC, Collections.directions.LEFT)
	$Shallan.setup_npc(NPCDatabase.npcs.SHALLAN, Collections.directions.DOWN)


func set_transition_tile_ids() -> void:
	$TransitionToStartOfJourney.scene_id = AreaDatabase.area_ids.START_OF_JOURNEY
	$TransitionImaginationLevel1.scene_id = AreaDatabase.area_ids.IMAGINATION_LEVEL_1
