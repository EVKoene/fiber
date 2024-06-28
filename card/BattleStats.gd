extends Node


class_name BattleStats

var attack: int: get = _get_attack
var health: int: get = _get_health
var movement: int: get = _get_movement

var base_attack: int
var base_health: int
var base_movement: int

var card: CardInPlay

var attack_modifiers: Array = []
var health_modifiers: Array = []
var movement_modifiers: Array = []


func _init(_base_attack, _base_health, _base_movement, _card):
	base_attack = _base_attack
	base_health = _base_health
	base_movement = _base_movement
	card = _card


func change_attack(value: int, turn_duration: int) -> void:
	if turn_duration == -1:
		base_attack += value
	else:
		attack_modifiers.append([value, turn_duration])
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


func _get_attack() -> int:
	var modified_attack = base_attack
	modified_attack += card.play_space.stat_modifier[
		card.card_owner_id
	][Collections.stats.ATTACK]

	for m in attack_modifiers:
		modified_attack += m[0]
	return modified_attack


func _get_health() -> int:
	var modified_health = base_health
	modified_health += card.play_space.stat_modifier[
		card.card_owner_id
	][Collections.stats.HEALTH]

	for m in health_modifiers:
		modified_health += m[0]
	return modified_health


func _get_movement() -> int:
	var modified_movement: int = base_movement
	modified_movement += card.play_space.stat_modifier[
		card.card_owner_id
	][Collections.stats.MOVEMENT]

	for m in movement_modifiers:
		modified_movement += m[0]
	return modified_movement


func update_modifiers() -> void:
	for modifier in [attack_modifiers, health_modifiers, movement_modifiers]:
		var modifiers_to_remove: Array = []
		for m in range(len(modifier)):
			modifier[m][1] -= 1
			if modifier[m][1] == 0:
				modifiers_to_remove.push_front(m)

		for r in modifiers_to_remove:
			modifier.remove_at(r)
	
