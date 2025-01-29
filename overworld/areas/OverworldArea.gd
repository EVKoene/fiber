extends Node2D

class_name OverworldArea

var pause_menu: Control
var player_position: Vector2
var player_body: CharacterBody2D
@export var scene_id: int


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


func improve_area(_npc_id: int) -> void:
	pass


func start_npc_interaction(npc_id: int) -> void:
	OverworldManager.can_move = false
	var npc_properties: Dictionary = NPCDatabase.npc_data[npc_id]
	read_text(npc_properties["Dialogue"])
	await Events.dialogue_finished
	if npc_properties.has("DeckID"):
		OverworldManager.save_player_position(
			$PlayerBody.position, scene_id
		)
		TransitionScene.transition_to_npc_battle(npc_id)
	else:
		OverworldManager.can_move = true


func read_text(text_to_read: Array, is_question := false, question_options := []) -> void:
	OverworldManager.overworld_textbox.read_text(text_to_read, is_question, question_options)
