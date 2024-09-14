extends Node


class_name BattleStats

var max_attack: int: get = _get_max_attack
var min_attack: int: get = _get_min_attack
var health: int: get = _get_health
var movement: int: get = _get_movement

var base_max_attack: int
var base_min_attack: int
var base_health: int
var base_movement: int

var card: CardInPlay

var max_attack_modifiers: Array = []
var min_attack_modifiers: Array = []
var health_modifiers: Array = []
var movement_modifiers: Array = []


func _init(
	_base_max_attack: int, _base_min_attack: int, _base_health: int, _base_movement: int, 
	_card: CardInPlay
):
	base_max_attack = _base_max_attack
	base_min_attack = _base_min_attack
	base_health = _base_health
	base_movement = _base_movement
	card = _card


func change_max_attack(value: int, turn_duration: int) -> void:
	if turn_duration == -1:
		base_max_attack += value
	else:
		max_attack_modifiers.append([value, turn_duration])
	card.update_stats()


func change_min_attack(value: int, turn_duration: int) -> void:
	if turn_duration == -1:
		base_min_attack += value
	else:
		min_attack_modifiers.append([value, turn_duration])
	card.update_stats()


func change_health(value: int, turn_duration: int) -> void:
	if turn_duration == -1:
		base_health += value
	else:
		health_modifiers.append([value, turn_duration])
	card.update_stats()


func change_movement(value: int, turn_duration: int) -> void:
	if turn_duration == -1:
		base_movement += value
	else:
		movement_modifiers.append([value, turn_duration])
	card.update_stats()


func _get_max_attack() -> int:
	var modified_attack = base_max_attack
	modified_attack += card.current_play_space.stat_modifier[
		card.card_owner_id
	][Collections.stats.MAX_ATTACK]

	for m in max_attack_modifiers:
		modified_attack += m[0]
	return modified_attack


func _get_min_attack() -> int:
	var modified_attack = base_min_attack
	modified_attack += card.current_play_space.stat_modifier[
		card.card_owner_id
	][Collections.stats.MIN_ATTACK]

	for m in min_attack_modifiers:
		modified_attack += m[0]
	return modified_attack


func _get_health() -> int:
	var modified_health = base_health
	modified_health += card.current_play_space.stat_modifier[
		card.card_owner_id
	][Collections.stats.HEALTH]

	for m in health_modifiers:
		modified_health += m[0]
		if modified_health < 1:
			modified_health = 1
			base_health = 1
	
	return modified_health


func _get_movement() -> int:
	var modified_movement: int = base_movement
	modified_movement += card.current_play_space.stat_modifier[
		card.card_owner_id
	][Collections.stats.MOVEMENT]

	for m in movement_modifiers:
		modified_movement += m[0]
	return modified_movement


@rpc("any_peer", "call_local")
func update_modifiers() -> void:
	for modifier in [
		max_attack_modifiers, min_attack_modifiers, health_modifiers, movement_modifiers
	]:
		var modifiers_to_remove: Array = []
		for m in range(len(modifier)):
			modifier[m][1] -= 1
			if modifier[m][1] == 0:
				modifiers_to_remove.push_front(m)

		for r in modifiers_to_remove:
			modifier.remove_at(r)
