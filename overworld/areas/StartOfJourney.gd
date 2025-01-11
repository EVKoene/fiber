extends "res://overworld/areas/OverworldArea.gd"


const WISE_MAN_WALKING_RATE = 0.5

var new_game := false
var tween: Tween
var wise_man: NPCBody
var wise_man_position := Vector2(309, 319)
var start_dialogue := ["
	Hi. Welcome", "Humanity is failing.", "In order to save the world we have to connect to our 
	core value.", "Which is: "
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.npc_interaction_started.connect(start_npc_interaction)
	GameManager.current_scene = self
	pause_menu = $GUI/PauseMenu
	player_body = $PlayerBody
	$PlayerBody.position = player_position
	wise_man = $WiseMan
	wise_man_position = wise_man.position
	if new_game:
		_walk_to_player_and_start_conversation()
	else:
		OverworldManager.can_move = true


func _walk_to_player_and_start_conversation() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	wise_man.position = Vector2(300, 100)
	wise_man.play_animation(
		wise_man.npc_id, Collections.directions.DOWN, Collections.animation_types.WALKING
	)
	tween.tween_property(
		wise_man, "position", 1.0, WISE_MAN_WALKING_RATE
	)
	tween.tween_callback(_start_of_journey_conversation)


func _start_of_journey_conversation() -> void:
	OverworldManager.can_move = false
	var npc_properties: Dictionary = NPCDatabase.npc_data[wise_man]
	read_text(npc_properties["Dialogue"])
	await Events.dialogue_finished
	if npc_properties["Deck"]:
		OverworldManager.save_player_position()
		TransitionScene.transition_to_npc_battle(npc_id)
