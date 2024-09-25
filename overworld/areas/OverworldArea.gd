extends Node2D

class_name OverworldArea


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.npc_interaction_started.connect(start_npc_interaction)
	GameManager.main_menu.current_area = self


func start_npc_interaction(npc_id: int) -> void:
	var npc_dialogue: Array = NPCDatabase.npc_data[npc_id]["Dialogue"]
	OverworldManager.overworld_textbox.read_text(npc_dialogue)
	await Events.dialogue_finished
	TransitionScene.transition_to_npc_battle(npc_id)
