extends OverworldArea


func setup_npcs() -> void:
	$Hans.setup_npc(NPCDatabase.npcs.HANS, Collections.directions.LEFT)
	$Jacques.setup_npc(NPCDatabase.npcs.JACQUES, Collections.directions.RIGHT)
	$Masha.setup_npc(NPCDatabase.npcs.MASHA, Collections.directions.UP)
	$Gary.setup_npc(NPCDatabase.npcs.GARY, Collections.directions.DOWN)


func set_transition_tile_ids() -> void:
	$TransitionPassionLevel1.scene_id = AreaDatabase.area_ids.PASSION_LEVEL_1
	$TransitionStartOfJourney.scene_id = AreaDatabase.area_ids.START_OF_JOURNEY
