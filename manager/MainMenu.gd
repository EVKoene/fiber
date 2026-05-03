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


func _on_start_pressed() -> void:
	$MainMenuContainer/VBoxContainer.hide()
	_populate_npc_list()
	$MainMenuContainer/NPCPicker.show()


func _populate_npc_list() -> void:
	var npc_list := $MainMenuContainer/NPCPicker/NPCList
	for child in npc_list.get_children():
		child.queue_free()
	
	for npc_id in NPCDatabase.npc_data:
		var npc_info: Dictionary = NPCDatabase.npc_data[npc_id]
		if npc_info.get("Battle", false) == true:
			var button := Button.new()
			button.text = npc_info["Name"]
			button.pressed.connect(_on_npc_selected.bind(npc_id))
			npc_list.add_child(button)


func _on_npc_selected(npc_id: int) -> void:
	TransitionScene.transition_to_npc_battle(npc_id)


func _on_npc_picker_back_pressed() -> void:
	$MainMenuContainer/NPCPicker.hide()
	$MainMenuContainer/VBoxContainer.show()
