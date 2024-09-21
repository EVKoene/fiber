extends CharacterBody2D

@export var npc: int
@export var direction: int


func _ready():
	$AnimatedSprite2D.play(
		NPCDatabase.npc_animation(npc, direction, Collections.animation_types.IDLE)
	) 
