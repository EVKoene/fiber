extends Control

class_name MainMenu


var tutorial_scene := load("res://singleplayer/Tutorial.tscn")
var current_deck_label: Node


func _ready():
	current_deck_label = $DeckButtons/CurrentDeck
	GameManager.main_menu = self
	GameManager.set_current_deck(DeckCollection.random_deck())


func _start_tutorial() -> void:
	var tutorial = tutorial_scene.instantiate()
	tutorial.size = MapSettings.total_screen
	add_child(tutorial)
	hide_main_menu()


func hide_main_menu() -> void:
	$CenterContainer.hide()
	$TestingButton.hide()
	$DeckButtons.hide()


func show_main_menu() -> void:
	$CenterContainer.show()
	$TestingButton.show()
	$DeckButtons.show()


func _on_start_pressed():
	GameManager.lobby.start_game.rpc()

func _on_join_random_pressed():
	MultiplayerManager.join_random_game()

func _on_host_lan_pressed():
	MultiplayerManager.become_lan_host()

func _on_join_lan_pressed():
	MultiplayerManager.join_lan_game()
	

func _on_testing_button_pressed():
	if GameManager.testing:
		GameManager.lobby.set_current_deck(DeckCollection.random_deck())
		$TestingButton.text = "Turn on testing"
		GameManager.testing = false
		$CenterContainer/VBoxContainer/IPAddress.show()
	else:
		GameManager.lobby.set_current_deck(DeckCollection.player_testing)
		$TestingButton.text = "Turn off testing"
		GameManager.testing = true
		$CenterContainer/VBoxContainer/IPAddress.hide()


func _on_animal_deck_button_pressed():
	GameManager.lobby.set_current_deck(DeckCollection.animal)


func _on_magic_deck_button_pressed():
	GameManager.lobby.set_current_deck(DeckCollection.magic)


func _on_nature_deck_button_pressed():
	GameManager.lobby.set_current_deck(DeckCollection.nature)


func _on_robot_deck_button_pressed() -> void:
	GameManager.lobby.set_current_deck(DeckCollection.robot)


func _on_random_deck_button_pressed():
	GameManager.lobby.set_current_deck(DeckCollection.random_deck())


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_single_player_pressed() -> void:
	GameManager.lobby.go_to_overworld()


func _on_tutorial_pressed():
	_start_tutorial()


func _on_dedicated_server_pressed():
	MultiplayerManager.become_dedicated_server_host()
