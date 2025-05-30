extends Node

class_name BattleStats

var card: CardInPlay
var battle_stats_container: BattleStatsContainer

var attack_range: int:
	get = get_attack_range
var health: int:
	get = get_health
var max_attack: int:
	get = get_max_attack
var min_attack: int:
	get = get_min_attack
var movement: int:
	get = get_movement
var shield: int:
	get = get_shield

var base_attack_range: int
var base_health: int
var base_max_attack: int
var base_min_attack: int
var base_movement: int
var base_shield := 0


var attack_range_modifiers := []
var max_attack_modifiers := []
var min_attack_modifiers := []
var health_modifiers := []
var shield_modifiers := []
var movement_modifiers := []


func _init(
	_base_max_attack: int,
	_base_min_attack: int,
	_base_health: int,
	_base_movement: int,
	_base_attack_range: int,
	_card: Card
):
	base_max_attack = _base_max_attack
	base_min_attack = _base_min_attack
	base_health = _base_health
	base_movement = _base_movement
	base_attack_range = _base_attack_range
	card = _card



func set_base_stats() -> void:
	battle_stats_container.update_stat(Collections.stats.ATTACK_RANGE, base_attack_range)
	battle_stats_container.update_stat(Collections.stats.HEALTH, base_health)
	battle_stats_container.update_stat(Collections.stats.MAX_ATTACK, base_max_attack)
	battle_stats_container.update_stat(Collections.stats.MIN_ATTACK, base_min_attack)
	battle_stats_container.update_stat(Collections.stats.MOVEMENT, base_movement)
	battle_stats_container.update_stat(Collections.stats.SHIELD, base_shield)


func update_all_stats() -> void:
	battle_stats_container.update_stat(Collections.stats.ATTACK_RANGE, attack_range)
	battle_stats_container.update_stat(Collections.stats.HEALTH, health)
	battle_stats_container.update_stat(Collections.stats.MAX_ATTACK, max_attack)
	battle_stats_container.update_stat(Collections.stats.MIN_ATTACK, min_attack)
	battle_stats_container.update_stat(Collections.stats.MOVEMENT, movement)
	battle_stats_container.update_stat(Collections.stats.SHIELD, shield)


func change_battle_stat(battle_stat: int, value: int, turn_duration: int) -> void:
	match battle_stat:
		Collections.stats.HEALTH:
			if turn_duration == -1:
				base_health += value
			else:
				health_modifiers.append([value, turn_duration])

		Collections.stats.MAX_ATTACK:
			if turn_duration == -1:
				base_max_attack += value
			else:
				max_attack_modifiers.append([value, turn_duration])

		Collections.stats.MIN_ATTACK:
			if turn_duration == -1:
				if base_min_attack < base_max_attack:
					base_min_attack += value
				else:
					base_max_attack += value
			else:
				if min_attack < max_attack:
					min_attack_modifiers.append([value, turn_duration])
				else:
					max_attack_modifiers.append([value, turn_duration])

		Collections.stats.SHIELD:
			if turn_duration == -1:
				base_shield += value
			else:
				shield_modifiers.append([value, turn_duration])
			if base_shield < 0:
				base_shield = 0

		Collections.stats.MOVEMENT:
			if turn_duration == -1:
				base_movement += value
			else:
				movement_modifiers.append([value, turn_duration])
		
		Collections.stats.ATTACK_RANGE:
			if turn_duration == -1:
				base_attack_range += value
			else:
				attack_range_modifiers.append([value, turn_duration])
	
	battle_stats_container.update_stat(battle_stat, value)


func get_max_attack() -> int:
	var modified_attack = base_max_attack
	modified_attack += card.current_play_space.stat_modifier[card.card_owner_id][
		Collections.stats.MAX_ATTACK
	]

	for m in max_attack_modifiers:
		modified_attack += m[0]
	return modified_attack


func get_min_attack() -> int:
	var modified_attack = base_min_attack
	modified_attack += card.current_play_space.stat_modifier[card.card_owner_id][
		Collections.stats.MIN_ATTACK
	]

	for m in min_attack_modifiers:
		modified_attack += m[0]
	return modified_attack


func get_health() -> int:
	var modified_health = base_health
	modified_health += card.current_play_space.stat_modifier[card.card_owner_id][
		Collections.stats.HEALTH
	]

	for m in health_modifiers:
		modified_health += m[0]
		if modified_health < 1:
			modified_health = 1
			base_health = 1

	return modified_health


func get_shield() -> int:
	var modified_shield = base_shield
	modified_shield += card.current_play_space.stat_modifier[card.card_owner_id][
		Collections.stats.SHIELD
	]

	for m in shield_modifiers:
		modified_shield += m[0]
	return modified_shield


func get_movement() -> int:
	var modified_movement: int = base_movement
	modified_movement += card.current_play_space.stat_modifier[card.card_owner_id][
		Collections.stats.MOVEMENT
	]

	for m in movement_modifiers:
		modified_movement += m[0]
	return modified_movement


func get_attack_range() -> int:
	var modified_attack_range: int = base_attack_range
	modified_attack_range += card.current_play_space.stat_modifier[card.card_owner_id][
		Collections.stats.ATTACK_RANGE
	]

	for m in attack_range_modifiers:
		modified_attack_range += m[0]
	return modified_attack_range


@rpc("any_peer", "call_local")
func update_modifiers() -> void:
	for modifier in [
		max_attack_modifiers,
		min_attack_modifiers,
		health_modifiers,
		movement_modifiers,
		attack_range_modifiers,
		shield_modifiers
	]:
		var modifiers_to_remove: Array = []
		for m in range(len(modifier)):
			modifier[m][1] -= 1
			if modifier[m][1] == 0:
				modifiers_to_remove.push_front(m)

		for r in modifiers_to_remove:
			modifier.remove_at(r)
	
	update_all_stats()
