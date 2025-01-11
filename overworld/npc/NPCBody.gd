extends CharacterBody2D


class_name NPCBody


@export var npc_name: String
@export var direction: int
var npc_id: int: get = _get_npc_id


func _ready():
	play_animation(
		npc_id, direction, Collections.animation_types.IDLE
	) 


func play_animation(animation_npc_id: int, animation_direction: int, animation_types: int) -> void:
	$AnimatedSprite2D.play(
		NPCDatabase.npc_animation(animation_npc_id, animation_direction, animation_types)
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
		"Guru Trong":
			id_to_return = NPCDatabase.npcs.GURU_TRONG
		"Guru Laghima":
			id_to_return = NPCDatabase.npcs.GURU_LAGHIMA
		"Shallan":
			id_to_return = NPCDatabase.npcs.SHALLAN
		"Businessperson Leonardo":
			id_to_return = NPCDatabase.npcs.BUSINESS_PERSON_LEONARDO
		"Businessperson Ana":
			id_to_return = NPCDatabase.npcs.BUSINESS_PERSON_ANA
		"Businessperson Jeroen":
			id_to_return = NPCDatabase.npcs.BUSINESS_PERSON_JEROEN
		"Bill Gates":
			id_to_return = NPCDatabase.npcs.BILL_GATES
		"Wise Man":
			id_to_return = NPCDatabase.npcs.WISE_MAN
	
	return id_to_return
		
