"""
This script was made to not bloat the CardInPlay script too much. Any functions that are used by or
for cards can be put here. 
"""

extends Node

@onready var card_scene = preload("res://card/CardInPlay.tscn")


func cards_in_range(
	card: CardInPlay, card_range: int, target_restrictions: int, ignore_obstacles: bool
) -> Array:
	var cards: Array = []
	for p in GameManager.cards_in_play:
		for c in GameManager.cards_in_play[p]:
			match target_restrictions:
				TargetSelection.target_restrictions.ANY_UNITS:
							if card.current_play_space.distance_to_play_space(
								c.current_play_space, ignore_obstacles
							) <= card_range:
								cards.append(c)
				TargetSelection.target_restrictions.OWN_UNITS:
					if (
						card.current_play_space.distance_to_play_space(
						c.current_play_space, ignore_obstacles
						) <= card_range 
						and card.card_owner_id == c.card_owner_id 
					):
						cards.append(c)
				TargetSelection.target_restrictions.OWN_UNITS:
					if (
						card.current_play_space.distance_to_play_space(
						c.current_play_space, ignore_obstacles
						) <= card_range 
						and card.card_owner_id != c.card_owner_id 
					):
						cards.append(c)
	
	return cards


func on_resource_space(card: CardInPlay) -> bool:
	if Collections.play_space_attributes.RESOURCE_SPACE in card.current_play_space.attributes:
		return true
	elif Collections.play_space_attributes.DRAW_CARD_SPACE in card.current_play_space.attributes:
		return true
	else:
		return false


func distance_to_closest_enemy_unit(card: CardInPlay) -> int:
	var shortest_distance: int = -1
	for c in GameManager.cards_in_play[GameManager.opposing_player_id(card.card_owner_id)]:
		var distance_to_unit = card.current_play_space.distance_to_play_space(
			c.current_play_space, false
		)
		if shortest_distance == -1 and distance_to_unit >= 1:
			shortest_distance = distance_to_unit
		elif shortest_distance != -1 and distance_to_unit < shortest_distance:
			shortest_distance = distance_to_unit
	
	return shortest_distance


func closest_enemy_units(card: CardInPlay) -> Array:
	var shortest_distance: int = -1
	var closest_cards: Array
	for c in GameManager.cards_in_play[GameManager.opposing_player_id(card.card_owner_id)]:
		var distance_to_unit = card.current_play_space.distance_to_play_space(
			c.current_play_space, false
		)
		if shortest_distance == -1 and distance_to_unit >= 1:
			shortest_distance = distance_to_unit
			closest_cards = [c]
		elif shortest_distance != -1 and distance_to_unit == shortest_distance:
			closest_cards.append(c)
		elif shortest_distance != -1 and distance_to_unit < shortest_distance:
			shortest_distance = distance_to_unit
			closest_cards = [c]
	
	return closest_cards


func n_cards_in_adjacent_play_spaces(card: CardInPlay, target_restrictions: int) -> int:
	var n: int = 0
	for ps in card.current_play_space.adjacent_play_spaces():
		if ps.card_in_this_play_space:
			match [target_restrictions, ps.card_in_this_play_space.card_owner == card.card_owner]:
				[TargetSelection.target_restrictions.ANY_UNITS, true]:
					n += 1
				[TargetSelection.target_restrictions.ANY_UNITS, false]:
					n += 1
				[TargetSelection.target_restrictions.OWN_UNITS, true]:
					n += 1
				[TargetSelection.target_restrictions.OPPONENT_UNITS, false]:
					n += 1

	return n


func in_starting_area(card: CardInPlay) -> bool:
	if (
		card.card_owner_id == GameManager.p1_id and 
		Collections.play_space_attributes.P1_START_SPACE not in card.current_play_space.attributes
	):
		return true
	elif (
		card.card_owner_id == GameManager.p2_id and 
		Collections.play_space_attributes.P2_START_SPACE not in card.current_play_space.attributes
	):
		return true
	return false
