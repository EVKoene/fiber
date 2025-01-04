extends CharacterBody2D

@export var npc_name: String
@export var direction: int
var npc_id: int: get = _get_npc_id


func _ready():
	$AnimatedSprite2D.play(
		NPCDatabase.npc_animation(npc_id, direction, Collections.animation_types.IDLE)
	) 


func _get_npc_id() -> int:
	var id_to_return: int
	match npc_name:
		"Hans":
			id_to_return = NPCDatabase.npc_ids.HANS
		"Masha":
			id_to_return = NPCDatabase.npc_ids.MASHA
		"Jacques":
			id_to_return = NPCDatabase.npc_ids.JACQUES
		"Gary":
			id_to_return = NPCDatabase.npc_ids.GARY
		"Dal":
			id_to_return = NPCDatabase.npc_ids.STUDENT_DAL
		"Mac":
			id_to_return = NPCDatabase.npc_ids.STUDENT_MAC
		"Kala":
			id_to_return = NPCDatabase.npc_ids.STUDENT_KALA
		"Rob":
			id_to_return = NPCDatabase.npc_ids.ROB
		"Jesus":
			id_to_return = NPCDatabase.npc_ids.JESUS
		"Guru Flappie":
			id_to_return = NPCDatabase.npc_ids.GURU_FLAPPIE
		"Guru Kal":
			id_to_return = NPCDatabase.npc_ids.GURU_KAL
		"Guru Flappie":
			id_to_return = NPCDatabase.npc_ids.GURU_TRONG
		"Guru Laghima":
			id_to_return = NPCDatabase.npc_ids.GURU_LAGHIMA
		"Shallan":
			id_to_return = NPCDatabase.npc_ids.SHALLAN
	
	return id_to_return
		
