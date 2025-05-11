extends "res://overworld/areas/OverworldArea.gd"


const WISE_MAN_WALKING_RATE = 1.5

@onready var save_path := "user://savedata/"
@onready var overworld_file := str(save_path, "overworld.ini")
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
	setup_npcs()
	if new_game:
		OverworldManager.can_move = false
		player_body.current_direction = Collections.directions.UP
		player_body.play_animation(0)
		await get_tree().create_timer(1).timeout
		_walk_to_player_and_start_conversation()
	else:
		OverworldManager.can_move = true
	set_transition_tile_ids()


func setup_npcs() -> void:
	wise_man = $WiseMan
	wise_man_id = NPCDatabase.npcs.WISE_MAN
	$Alphonso.setup_npc(NPCDatabase.npcs.ALPHONSO, Collections.directions.LEFT)
	$Betty.setup_npc(NPCDatabase.npcs.BETTY, Collections.directions.RIGHT)
	$Gamza.setup_npc(NPCDatabase.npcs.GAMZA, Collections.directions.DOWN)
	
	var config := ConfigFile.new()
	assert(FileAccess.file_exists(overworld_file), "Couldn't access save file. Please restart the game")
	
	config.load(overworld_file)
	if !config.has_section("progress"):
		new_game = true
	
	var current_defeated_npc_ids: Array = config.get_value("progress", "defeated_npcs", [])
	if !new_game:
		$Alphonso.show()
	if NPCDatabase.npcs.ALPHONSO in current_defeated_npc_ids:
		$Betty.show()
	if NPCDatabase.npcs.BETTY in current_defeated_npc_ids:
		$Gamza.show()
	if NPCDatabase.npcs.GAMZA in current_defeated_npc_ids:
		$BlockPassion.hide()
	
	
	$WiseMan.setup_npc(NPCDatabase.npcs.WISE_MAN, Collections.directions.DOWN)


func set_transition_tile_ids() -> void:
	$TransitionStartOfGrowth.scene_id = AreaDatabase.area_ids.START_OF_GROWTH
	$TransitionStartOfImagination.scene_id = AreaDatabase.area_ids.START_OF_IMAGINATION
	$TransitionStartOfPassion.scene_id = AreaDatabase.area_ids.START_OF_PASSION
	$TransitionStartOfLogic.scene_id = AreaDatabase.area_ids.START_OF_LOGIC


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
	_set_intro_talk_completed()
	if play_tutorial == 0:
		TransitionScene.transition_to_tutorial()
	else:
		OverworldManager.can_move = true
		setup_npcs()
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


func _set_intro_talk_completed() -> void:
	new_game = false
	var config := ConfigFile.new()
	assert(FileAccess.file_exists(overworld_file), "Couldn't access save file. Please restart the game")
	config.load(overworld_file)
	config.set_value("progress", "completed_intro", true)
	config.save(overworld_file)
