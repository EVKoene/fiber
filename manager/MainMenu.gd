extends Control

class_name MainMenu


@onready var prompt_container := $PromptContainer

var prompt_scene := load("res://manager/YesNoPrompt.tscn")


func _ready():
	$MultiplayerSpawner.add_spawnable_scene("res://manager/TurnManager.tscn")
	GameManager.main_menu = self


func show_prompt(prompt_text: String) -> void:
	var prompt = prompt_scene.instantiate()
	prompt.prompt_text = prompt_text
	prompt.main_menu = self
	$PromptContainer.show()
	$PromptContainer.move_to_front()
	$PromptContainer.add_child(prompt)


func hide_main_menu() -> void:
	$MainMenuContainer.hide()
	$TestingButton.hide()


func show_main_menu() -> void:
	$MainMenuContainer.show()
	$TestingButton.show()


@rpc("any_peer")
func show_start_game_button() -> void:
	$MainMenuContainer/VBoxContainer/Start.show()


func _on_start_pressed():
	GameManager.start_game.rpc()

func _on_join_random_pressed():
	MultiplayerManager.join_random_game()

func _on_host_lan_pressed():
	MultiplayerManager.become_lan_host()

func _on_join_lan_pressed():
	MultiplayerManager.join_lan_game()
	

func _on_testing_button_pressed():
	if GameManager.testing:
		GameManager.set_current_deck(DeckCollection.random_starter_deck_id())
		$TestingButton.text = "Turn on testing"
		GameManager.testing = false
		$MainMenuContainer/VBoxContainer/IPAddress.show()
		$MainMenuContainer/VBoxContainer/ShowIPAdress.show()
	else:
		GameManager.set_current_deck(DeckCollection.deck_ids.PLAYER_TESTING)
		$TestingButton.text = "Turn off testing"
		GameManager.testing = true
		$MainMenuContainer/VBoxContainer/IPAddress.hide()
		$MainMenuContainer/VBoxContainer/ShowIPAdress.hide()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_single_player_pressed() -> void:
	GameManager.is_server = true
	GameManager.testing = false
	
	if !FileAccess.file_exists(GameManager.collections_path):
		TransitionScene.transition_to_start_journey()
		return
	
	var config := ConfigFile.new()
	config.load(GameManager.collections_path)
	if config.get_value("start_journey", "starting_fiber", -1) == -1:
		TransitionScene.transition_to_start_journey()
		return
	
	TransitionScene.transition_to_overworld_scene(AreaDatabase.area_ids.START_OF_JOURNEY)


func _on_tutorial_pressed():
	GameManager.is_server = true
	Tutorial.setup_tutorial()


func _on_dedicated_server_pressed():
	MultiplayerManager.become_dedicated_server_host()


func _on_show_ip_adress_pressed():
	$YourIPLabel.text = str("Your IP: ", IP.get_local_addresses()[3])
	$YourIPLabel.show()


func _on_test_game_pressed():
	GameManager.testing = true
	GameManager.is_server = true
	TransitionScene.transition_to_test_battle()
