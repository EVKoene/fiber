extends OverworldArea


func setup_npcs() -> void:
	$Rambo.setup_npc(NPCDatabase.npcs.RAMBO, Collections.directions.UP)
	$Trudy.setup_npc(NPCDatabase.npcs.TRUDY, Collections.directions.UP)
	$Ingrid.setup_npc(NPCDatabase.npcs.INGRID, Collections.directions.LEFT)
	$Yaya.setup_npc(NPCDatabase.npcs.YAYA, Collections.directions.DOWN)


func set_transition_tile_ids() -> void:
	$TransitionStartOfPassion.scene_id = AreaDatabase.area_ids.START_OF_PASSION


func improve_area(npc_id: int) -> void:
	match npc_id:
		NPCDatabase.npcs.TRUDY:
			_change_television_to_pool_table()
		_:
			return


func _change_television_to_pool_table() -> void:
	$Rambo.position = Vector2(-90, -360)
	$Rambo.direction = Collections.directions.DOWN
	$Rambo.play_animation($Rambo.npc_id, $Rambo.direction, Collections.animation_types.IDLE)
	$Trudy.direction = Collections.directions.UP
	$Trudy.play_animation($Trudy.npc_id, $Trudy.direction, Collections.animation_types.IDLE)
	$Television.hide()
	$PoolTable.show()
