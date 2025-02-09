extends OverworldArea


func setup_npcs() -> void:
	$Adolin.setup_npc(NPCDatabase.npcs.ADOLIN, Collections.directions.DOWN)
	$Kaladin.setup_npc(NPCDatabase.npcs.KALADIN, Collections.directions.LEFT)
	$Dalinar.setup_npc(NPCDatabase.npcs.DALINAR, Collections.directions.LEFT)


func set_transition_tile_ids() -> void:
	$TransitionStartOfGrowth.scene_id = AreaDatabase.area_ids.START_OF_GROWTH
	$TransitionStartOfImagination.scene_id = AreaDatabase.area_ids.START_OF_IMAGINATION
