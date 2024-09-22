extends CharacterBody2D

@export var npc_id: int
@export var direction: int


func _ready():
	$AnimatedSprite2D.play(
		NPCDatabase.npc_animation(npc_id, direction, Collections.animation_types.IDLE)
	) 
