extends Control

class_name MainMenu

@onready var prompt_container := $PromptContainer
@onready var save_path := "user://savedata/"
@onready var collections_path := str(save_path, "collections.ini")
@onready var config := ConfigFile.new()

var prompt_scene := load("res://manager/YesNoPrompt.tscn")

func _ready():
	$MultiplayerSpawner.add_spawnable_scene("res://manager/TurnManager.tscn")
	GameManager.main_menu = self
	config.load(collections_path)
	if !config.has_section("deck_data"):
		_create_savefile()


func _create_savefile() -> void:
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
	
	for fiber in Collections.all_fibers:
		DeckSetup.setup_starter_deck(fiber)


func load_game() -> void:
	var new_game := false
	


func show_prompt(prompt_text: String) -> void:
	var prompt = prompt_scene.instantiate()
	prompt.prompt_text = prompt_text
	prompt.main_menu = self
	$PromptContainer.show()
	$PromptContainer.move_to_front()
	$PromptContainer.add_child(prompt)


func hide_main_menu() -> void:
	$MainMenuContainer.hide()


func show_main_menu() -> void:
	$MainMenuContainer.show()


func show_pick_deck() -> void:
	$MainMenuContainer/DeckPicker.find_decks()
	$MainMenuContainer/VBoxContainer.hide()
	$MainMenuContainer/DeckPicker.show()
	$MainMenuContainer/DeckPicker.set_current_decks()


func hide_pick_deck() -> void:
	$MainMenuContainer/DeckPicker.hide()
	$MainMenuContainer/VBoxContainer.show()


@rpc("any_peer")
func show_start_game_button() -> void:
	$MainMenuContainer/VBoxContainer/Start.show()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_tutorial_pressed():
	GameManager.is_server = true
	Tutorial.setup_tutorial()


func _on_deck_editor_pressed() -> void:
	hide_main_menu()
	TransitionScene.transition_to_deck_builder(DeckSetup.deck["ID"])


func _on_deck_picker_pressed() -> void:
	show_pick_deck()


func _on_boss_1_pressed() -> void:
	TransitionScene.transition_to_npc_battle(NPCDatabase.npcs.ALPHONSO)


func _on_boss_2_pressed() -> void:
	TransitionScene.transition_to_npc_battle(NPCDatabase.npcs.BETTY)


func _on_boss_3_pressed() -> void:
	TransitionScene.transition_to_npc_battle(NPCDatabase.npcs.GAMZA)
