extends Node

class_name NormalOpponent


var abilities = {}
var dummies: Array[Card]
var dummies_ps: Array[PlaySpace]
var next_ability := {}


func prepare_next_turn_ability() -> void:
	# Always pick ability[0] as the first ability
	if len(next_ability) == 0:
		next_ability = abilities[0]
	
	else:
		var abilities_to_pick_from := []
		for ability in abilities.values():
			if ability["MinTurn"] > GameManager.ai_player.ai_turns + 1:
				continue
			if ability["MaxTurn"] < GameManager.ai_player.ai_turns + 1 and ability["MaxTurn"] != -1:
				continue
			
			for f in range(ability["WeightFactor"]):
				abilities_to_pick_from.append(ability)
		next_ability = abilities_to_pick_from.pick_random()
	
	next_ability["Prepare"].call()


func call_triggered_funcs(_trigger: int, _triggering_card: Card) -> void:
	pass
