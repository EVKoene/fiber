extends Node2D

class_name OverworldArea

var pause_menu: Control
var player_position: Vector2
var player_body: CharacterBody2D
var scene_id: int


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.npc_interaction_started.connect(start_npc_interaction)
	GameManager.current_scene = self
	pause_menu = $GUI/PauseMenu
	player_body = $PlayerBody
	$PlayerBody.position = player_position
	OverworldManager.can_move = true
	for npc_id in OverworldManager.defeated_npc_ids:
		improve_area(npc_id)
	set_transition_tile_ids()
	setup_npcs()


func set_transition_tile_ids() -> void:
	pass


func setup_npcs() -> void:
	pass


func improve_area(_npc_id: int) -> void:
	pass


func start_npc_interaction(npc_id: int) -> void:
	OverworldManager.can_move = false
	var npc_properties: Dictionary = NPCDatabase.npc_data[npc_id]
	var has_question_options: bool = len(npc_properties["QuestionOptions"]) >= 1
	if has_question_options:
		read_text(npc_properties["Dialogue"], has_question_options, npc_properties["QuestionOptions"])
	else:
		read_text(npc_properties["Dialogue"])
	await Events.dialogue_finished
	
	GameManager.raycast.interaction_in_progress = false
	if !npc_properties["Battle"]:
		OverworldManager.can_move = true
		return
		
	OverworldManager.save_player_position($PlayerBody.position, scene_id)
	TransitionScene.transition_to_npc_battle(npc_id)


func read_text(text_to_read: Array, is_question := false, question_options := {}) -> void:
	var option_texts = []
	for t in question_options:
		option_texts.append(question_options[t]["Text"])
	OverworldManager.overworld_textbox.read_text(text_to_read, is_question, option_texts)
	if is_question:
		var picked_option = await OverworldManager.mc_question_textbox.option_picked
		var option_func = question_options[question_options.keys()[picked_option]]["Func"]
		option_func.call()
