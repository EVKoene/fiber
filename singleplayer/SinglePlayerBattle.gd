extends Control

var player_deck: Dictionary
var npc: int
var npc_data = NPCDatabase.npc_data[npc]


func _init(_player_deck: Dictionary, _npc: int):
	player_deck = _player_deck
	npc = _npc


func start_battle() -> void:
	GameManager.testing = false
	GameManager.add_player_to_GameManager(
		1, "Player1", player_deck
	)
	
	GameManager.add_player_to_GameManager(
			2, "AIOpponent", npc_data["DeckID"]
		)
	GameManager.is_single_player = true
	var battle_map_scene: PackedScene = load("res://map/BattleMap.tscn")
	var battle_map = battle_map_scene.instantiate()
	add_child(battle_map, true)
