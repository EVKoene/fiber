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
			id_to_return = NPCDatabase.npcs.HANS
		"Masha":
			id_to_return = NPCDatabase.npcs.MASHA
		"Jacques":
			id_to_return = NPCDatabase.npcs.JACQUES
		"Gary":
			id_to_return = NPCDatabase.npcs.GARY
		"Student Dal":
			id_to_return = NPCDatabase.npcs.STUDENT_DAL
		"Student Mac":
			id_to_return = NPCDatabase.npcs.STUDENT_MAC
		"Student Kala":
			id_to_return = NPCDatabase.npcs.STUDENT_KALA
		"Rob":
			id_to_return = NPCDatabase.npcs.ROB
		"Jesus":
			id_to_return = NPCDatabase.npcs.JESUS
		"Guru Flappie":
			id_to_return = NPCDatabase.npcs.GURU_FLAPPIE
		"Guru Kal":
			id_to_return = NPCDatabase.npcs.GURU_KAL
		"Guru Flappie":
			id_to_return = NPCDatabase.npcs.GURU_TRONG
		"Guru Laghima":
			id_to_return = NPCDatabase.npcs.GURU_LAGHIMA
		"Shallan":
			id_to_return = NPCDatabase.npcs.SHALLAN
	
	return id_to_return
		
