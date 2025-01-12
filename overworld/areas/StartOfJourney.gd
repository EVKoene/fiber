extends "res://overworld/areas/OverworldArea.gd"


const WISE_MAN_WALKING_RATE = 1.5

@onready var save_path := "user://savedata/"
@onready var collections_path := str(save_path, "collections.ini")
@onready var wise_man_position := Vector2(300, 320)

var new_game := false
var tween: Tween
var wise_man: NPCBody
var wise_man_id
var start_dialogue := ["
	Hi. Welcome.", "Humanity is failing.", "In order to save the world we have to connect to our 
	core value.", "Which is: "
]
var finishing_dialogue := [
	"Interesting...", "To save the world I'll give you a deck of cards.", "Battle opponents and 
	collect new cards.", "You can create and edit decks by pressing e or escape outside of a battle.
	", "Would you like to play a tutorial?"
]
var fiber_options := ["Passion", "Imagination", "Growth", "Logic",]
var tutorial_options := ["Yes", "No"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.npc_interaction_started.connect(start_npc_interaction)
	GameManager.current_scene = self
	pause_menu = $GUI/PauseMenu
	player_body = $PlayerBody
	$PlayerBody.position = player_position
	wise_man = $WiseMan
	wise_man_id = NPCDatabase.npcs.WISE_MAN
	if new_game:
		OverworldManager.can_move = false
		player_body.current_direction = Collections.directions.UP
		player_body.play_animation(0)
		await get_tree().create_timer(1).timeout
		_walk_to_player_and_start_conversation()
	else:
		OverworldManager.can_move = true


func _walk_to_player_and_start_conversation() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	wise_man.play_animation(
		wise_man.npc_id, Collections.directions.DOWN, Collections.animation_types.WALKING
	)
	tween.tween_property(
		wise_man, "position", wise_man_position, WISE_MAN_WALKING_RATE
	)
	await tween.finished
	wise_man.play_animation(
		wise_man.npc_id, Collections.directions.DOWN, Collections.animation_types.IDLE
	)
	_start_of_journey_conversation()


func _start_of_journey_conversation() -> void:
	read_text(start_dialogue, true, fiber_options)
	var fiber: int = await OverworldManager.mc_question_textbox.option_picked
	_create_savefile()
	_pick_deck(fiber)
	read_text(finishing_dialogue, true, tutorial_options)
	var play_tutorial = await OverworldManager.mc_question_textbox.option_picked
	if play_tutorial == 0:
		TransitionScene.transition_to_tutorial()
	else:
		return


func _pick_deck(fiber: int) -> void:
	GameManager.setup_starter_deck(fiber)


func _create_savefile() -> void:
	var config := ConfigFile.new()
	if !FileAccess.file_exists(collections_path):
		var create_dir_error := DirAccess.make_dir_recursive_absolute(save_path)
		if create_dir_error:
			print("Error creating directory: ", error_string(create_dir_error))
	else:
		config.load(collections_path)
	
	config.set_value("deck_data", "decks", {})
	config.set_value("card_collection", "cards", {})
	var save_error := config.save(collections_path)
	if save_error:
		print("Error creating collections file: ", error_string(save_error))
