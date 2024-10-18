extends Node

class_name ServerManager

var lobbys := []
var open_lobbys := []


func add_player_to_lobby(player_id: int) -> void:
	if len(open_lobbys) >= 1:
		open_lobbys[0].add_player(player_id)
	else:
		var lobby = Lobby.new()
		lobbys.append(lobby)
		open_lobbys.append(lobby)
		lobby.add_player(player_id)
