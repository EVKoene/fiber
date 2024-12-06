extends Control

class_name MainMenu


@onready var prompt_container := $PromptContainer

var prompt_scene := load("res://manager/YesNoPrompt.tscn")
var current_deck_label: Node


func _ready():
	GameManager.setup_savefile()
	$MultiplayerSpawner.add_spawnable_scene("res://manager/TurnManager.tscn")
	current_deck_label = $DeckButtons/CurrentDeck
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
	$DeckButtons.hide()


func show_main_menu() -> void:
	$MainMenuContainer.show()
	$TestingButton.show()
	$DeckButtons.show()


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
		GameManager.set_current_deck(DeckCollection.random_deck())
		$TestingButton.text = "Turn on testing"
		GameManager.testing = false
		$MainMenuContainer/VBoxContainer/IPAddress.show()
	else:
		GameManager.set_current_deck(DeckCollection.player_testing["ID"])
		$TestingButton.text = "Turn off testing"
		GameManager.testing = true
		$MainMenuContainer/VBoxContainer/IPAddress.hide()


func _on_passion_deck_button_pressed():
	GameManager.set_current_deck(DeckCollection.passion_starter["ID"])


func _on_imagination_deck_button_pressed():
	GameManager.set_current_deck(DeckCollection.imagination_starter["ID"])


func _on_growth_deck_button_pressed():
	GameManager.set_current_deck(DeckCollection.growth_starter["ID"])


func _on_logic_deck_button_pressed() -> void:
	GameManager.set_current_deck(DeckCollection.logic_starter["ID"])


func _on_random_deck_button_pressed():
	GameManager.set_current_deck(DeckCollection.random_deck())


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_single_player_pressed() -> void:
	GameManager.is_server = true
	TransitionScene.transition_to_overworld_scene(AreaDatabase.area_ids.STARTING)


func _on_tutorial_pressed():
	GameManager.is_server = true
	Tutorial.setup_tutorial()


func _on_dedicated_server_pressed():
	MultiplayerManager.become_dedicated_server_host()
