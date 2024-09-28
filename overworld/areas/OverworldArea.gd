extends Node2D

class_name OverworldArea


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.npc_interaction_started.connect(start_npc_interaction)
	GameManager.main_menu.current_area = self


func start_npc_interaction(npc_id: int) -> void:
	OverworldManager.can_move = false
	var npc_properties: Dictionary = NPCDatabase.npc_data[npc_id]
	OverworldManager.overworld_textbox.read_text(npc_properties["Dialogue"])
	await Events.dialogue_finished
	if npc_properties["Deck"]:
		TransitionScene.transition_to_npc_battle(npc_id)
	else:
		OverworldManager.can_move = true
