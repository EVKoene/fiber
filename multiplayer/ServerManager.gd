extends Node

class_name ServerManager

var lobby_scene := load("res://multiplayer/Lobby.tscn")
var lobbys := {}
var open_lobbys := []


func add_player_to_lobby(
	p_id: int, player_name: String, p_deck: Dictionary
	) -> void:
	if len(open_lobbys) >= 1:
		var lobby: Node = open_lobbys[0]
		lobby.add_player(p_id, player_name, p_deck)
		print("Added player to lobby ", lobby.lobby_id)
	else:
		var lobby_id = len(lobbys)
		var lobby = lobby_scene.instantiate()
		GameManager.main_menu.add_child(lobby)
		lobbys[lobby_id] = lobby
		lobbys[lobby_id].add_player(p_id, player_name, p_deck)
		print("Added player to lobby ", lobby_id)
