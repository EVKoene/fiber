extends AIPlayer


func play_turn() -> void:
	match ai_turns:
		1: play_first_gorillas()
		2: play_second_gorillas()
		3: play_third_gorillas()
		5: play_fourth_gorillas()
	
	await GameManager.battle_map.get_tree().create_timer(0.25).timeout
	
	use_cards_in_play()
	await GameManager.battle_map.get_tree().create_timer(0.25).timeout
	# If the AI wins by conquering victory spaces, the battle map will be removed and they won't
	# be able to end the turn anymore
	if is_instance_valid(GameManager.battle_map) and !game_over:
		ai_turn_manager.end_turn()


func play_first_gorillas() -> void:
	play_to_closest_available_space(CardDatabase.cards.GORILLA, 3, 0)
	play_to_closest_available_space(CardDatabase.cards.GORILLA, 5, 0)


func play_second_gorillas() -> void:
	play_to_closest_available_space(CardDatabase.cards.GORILLA, 3, 0)
	play_to_closest_available_space(CardDatabase.cards.GORILLA, 5, 0)


func play_third_gorillas() -> void:
	play_to_closest_available_space(CardDatabase.cards.GORILLA_BATTLECALLER, 3, 0)
	play_to_closest_available_space(CardDatabase.cards.GORILLA_BATTLECALLER, 5, 0)


func play_fourth_gorillas() -> void:
	play_to_closest_available_space(CardDatabase.cards.GORILLA_KING, 3, 0)
	play_to_closest_available_space(CardDatabase.cards.GORILLA_KING, 5, 0)
	
