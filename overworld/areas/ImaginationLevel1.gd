extends OverworldArea


func setup_npcs() -> void:
	$GuruTrong.setup_npc(NPCDatabase.npcs.GURU_TRONG, Collections.directions.DOWN)
	$GuruKal.setup_npc(NPCDatabase.npcs.GURU_KAL, Collections.directions.LEFT)
	$GuruFlappie.setup_npc(NPCDatabase.npcs.GURU_FLAPPIE, Collections.directions.LEFT)
	$GuruLahima.setup_npc(NPCDatabase.npcs.GURU_LAGHIMA, Collections.directions.DOWN)


func set_transition_tile_ids() -> void:
	$TransitionStartOfJourney.scene_id = AreaDatabase.area_ids.START_OF_JOURNEY
	$TransitionStartOfImagination.scene_id = AreaDatabase.area_ids.START_OF_IMAGINATION
