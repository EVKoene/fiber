extends Node

### CARD ###
enum fibers {PASSION, IMAGINATION, GROWTH, LOGIC,}
var all_fibers: Array = [fibers.PASSION, fibers.IMAGINATION, fibers.GROWTH, fibers.LOGIC]
var faction_names: Dictionary = {
	fibers.PASSION: "Passion",
	fibers.IMAGINATION: "Imagination",
	fibers.GROWTH: "Growth",
	fibers.LOGIC: "Logic",
	}
enum card_types {SPELL, UNIT}
enum stat_params { LOWEST, HIGHEST, OVER_VALUE, UNDER_VALUE }
enum stats { MAX_ATTACK, MIN_ATTACK, HEALTH, MOVEMENT, SHIELD, TOTAL_COST }
enum triggers {
	ATTACK, ATTACK_FINISHED, CARD_ACTIVATION, CARD_ADDED_TO_HAND, CARD_CREATED, CARD_DESTROYED, 
	CARD_DISCARDED, CARD_MOVED, CARD_MOVING_AWAY, CARD_PLAY_STARTED, COMBAT_STARTED, SPELL_PLAYED, 
	TURN_STARTED, TURN_ENDED,
}
enum play_space_attributes {
	P1_START_SPACE, P2_START_SPACE, VICTORY_SPACE, 
}


### AI HELPER ###
enum purposes {
	BUFF_ADJACENT, CONQUER_SPACES, DEFEND_RESOURCE, BATTLE, REAR, DEBUFF_ADJACENT,
}
enum hint_types {NECESSARY, SUFFICIENT}
enum turn_stages {
	CARD_PLAYS, END_TURN, START_TURN
}


### MULTI PURPOSE ###
enum directions {DOWN, LEFT, RIGHT, UP}
enum players { P1, P2 }


### OVERWORLD ###
enum animation_types { IDLE, WALKING }


var stat_names := {
	stats.MAX_ATTACK: "Max Attack", 
	stats.MIN_ATTACK: "Min Attack", 
	stats.HEALTH: "Health", 
	stats.MOVEMENT: "Movement", 
	stats.TOTAL_COST: "Total cost",
}
### BATTLE ###
var turn_stage_names: Dictionary = {
		turn_stages.CARD_PLAYS: "CardPlays", 
		turn_stages.END_TURN: "EndTurn", 
		turn_stages.START_TURN:"StartTurn",
}
