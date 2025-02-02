extends OverworldArea

func setup_npcs() -> void:
	$Kwik.setup_npc(NPCDatabase.npcs.KWIK, Collections.directions.DOWN)
	$Kwek.setup_npc(NPCDatabase.npcs.KWEK, Collections.directions.DOWN)
	$Kwak.setup_npc(NPCDatabase.npcs.KWAK, Collections.directions.DOWN)


func set_transition_tile_ids() -> void:
	$TransitionToStartOfGrowth.scene_id = AreaDatabase.area_ids.START_OF_GROWTH
