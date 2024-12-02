"""
This script was made to not bloat the CardInPlay script too much. Any functions that are used by or
for cards can be put here. 
"""

extends Node

@onready var card_scene = preload("res://battle/card/card_states/CardInPlay.tscn")


func cards_in_range(
	player_id: int, card_range: int, target_restrictions: int, ignore_obstacles := true, 
) -> Array:
	var cards := []
	for card in GameManager.cards_in_play[player_id]:
		for c in cards_in_range_of_card(
			card, card_range, target_restrictions, ignore_obstacles, false
		):
			if c not in cards:
				cards.append(c)
	return cards


func cards_in_range_of_card(
	card: CardInPlay, card_range: int, target_restrictions: int, ignore_obstacles := true,
	include_self := false
) -> Array:
	var cards := []
	for p_id in GameManager.players:
		for c in GameManager.cards_in_play[p_id]:
			if c == card and !include_self:
				continue
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
				TargetSelection.target_restrictions.OPPONENT_UNITS:
					if (
						card.current_play_space.distance_to_play_space(
						c.current_play_space, ignore_obstacles
						) <= card_range 
						and card.card_owner_id != c.card_owner_id 
					):
						cards.append(c)
	
	return cards


func on_victory_space(card: CardInPlay) -> bool:
	if Collections.play_space_attributes.VICTORY_SPACE in card.current_play_space.attributes:
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


func closest_spaces_within_movement(
	card: CardInPlay, goal_space: PlaySpace
) -> Array: 
	var closest_spaces := []
	var closest_distance := -1
	var distance_to_goal_space := card.current_play_space.distance_to_play_space(
		goal_space, card.ignore_obstacles
	)
	if distance_to_goal_space  -1:
		return [goal_space]
	for ps in GameManager.play_spaces:
		var distance_to_ps: int = ps.distance_to_play_space(goal_space, card.ignore_obstacles)
		if distance_to_ps == -1:
			continue
		elif distance_to_ps < card.movement:
			continue
		elif distance_to_ps == closest_distance:
			closest_spaces.append(ps)
		elif distance_to_ps < closest_distance:
			closest_distance = distance_to_ps
			closest_spaces = ps
	
	return closest_spaces


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


func closest_conquerable_space(player_id: int, card: CardInPlay) -> Array:
	var shortest_distance: int = -1
	var closest_spaces: Array
	for ps in GameManager.victory_spaces:
		if ps.conquered_by == player_id:
			continue
		var distance_to_space = card.current_play_space.distance_to_play_space(
			ps, card.move_through_units
		)
		if shortest_distance == -1 and distance_to_space >= 1:
			shortest_distance = distance_to_space
			closest_spaces = [ps]
		elif shortest_distance != -1 and distance_to_space == shortest_distance:
			closest_spaces.append(ps)
		elif shortest_distance != -1 and distance_to_space < shortest_distance:
			shortest_distance = distance_to_space
			closest_spaces = [ps]
	
	return closest_spaces


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


func calc_n_lines(text: String) -> int:
	assert(
		len(text) <= 180,
		 str(
			"Card text too large for text box. Max text length: 180. Text length: ", len(text),
			". Card text: ", text
		)
	)
	if len(text) == 0:
		return 0
	elif len(text) <= 30:
		return 1
	elif len(text) <= 60:
		return 2
	elif len(text) <= 90:
		return 3
	elif len(text) <= 120:
		return 4
	elif len(text) <= 150:
		return 5
	else:
		return 6
