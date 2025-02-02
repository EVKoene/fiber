extends Node

@onready var save_path := "user://savedata/"
@onready var collections_file := str(save_path, "collections.ini")


func add_card_to_collection(card_index: int) -> void:
	var config := ConfigFile.new()
	config.load(collections_file)
	var current_cards_collection = config.get_value("card_collection", "cards")
	if card_index in current_cards_collection.keys():
		current_cards_collection[card_index] += 1
	else:
		current_cards_collection[card_index] = 1
	config.save(collections_file)


func get_battle_reward() -> Array:
	var rewards := []
	var opponent_deck: Dictionary = (
		GameManager.players[GameManager.opposing_player_id(GameManager.player_id)]["Deck"]
	)
	var n_rewards: int = [0, 1, 1, 1, 1, 2].pick_random()
	for c in range(n_rewards):
		rewards.append(pick_random_card(opponent_deck))

	return rewards


func pick_random_card(deck: Dictionary) -> int:
	var card_pool := []
	for c in deck["Cards"]:
		for n in deck["Cards"][c]:
			card_pool.append(c)

	return card_pool.pick_random()
