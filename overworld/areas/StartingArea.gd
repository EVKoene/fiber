extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.npc_interaction_started.connect(start_npc_interaction)

func start_npc_interaction(npc_id: int) -> void:
	var npc: int = instance_from_id(npc_id).npc
	var npc_dialogue: Array = NPCDatabase.npc_data[npc]["Dialogue"]
	Events.overworld_text_request.emit(npc_dialogue)
