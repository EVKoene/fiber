extends OverworldArea


# Called when the node enters the scene tree for the first time.
func setup_npcs() -> void:
	$BusinessPersonLeonardo.setup_npc(
		NPCDatabase.npcs.BUSINESS_PERSON_LEONARDO, Collections.directions.DOWN
	)
	$BusinessPersonAna.setup_npc(NPCDatabase.npcs.BUSINESS_PERSON_ANA, Collections.directions.DOWN)
	$BusinessPersonJeroen.setup_npc(
		NPCDatabase.npcs.BUSINESS_PERSON_JEROEN, Collections.directions.DOWN
	)
	$BillGates.setup_npc(NPCDatabase.npcs.BILL_GATES, Collections.directions.RIGHT)


func set_transition_tile_ids() -> void:
	$TransitionToStartOfJourney.scene_id = AreaDatabase.area_ids.START_OF_JOURNEY
