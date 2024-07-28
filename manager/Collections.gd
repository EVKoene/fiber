extends Node

var all_factions: Array = [factions.ANIMAL, factions.MAGIC, factions.NATURE, factions.ROBOT]

var faction_names: Dictionary = {
	factions.ANIMAL: "Animal",
	factions.MAGIC: "Magic",
	factions.NATURE: "Nature",
	factions.ROBOT: "Robot",
	}

var turn_stage_names: Dictionary = {
		turn_stages.CARD_PLAYS: "CardPlays", 
		turn_stages.END_TURN: "EndTurn", 
		turn_stages.START_TURN:"StartTurn",
}

enum purposes {
	BUFF_ADJACENT, DEFEND_RESOURCE, BATTLE, REAR, DEBUFF_ADJACENT,
}

enum card_types {SPELL, UNIT}
enum directions {DOWN, LEFT, RIGHT, UP}
enum factions {ANIMAL, MAGIC, NATURE, ROBOT,}
enum hint_types {NECESSARY, SUFFICIENT}
enum triggers {
	ATTACK, ATTACK_FINISHED, CARD_ACTIVATION, CARD_CREATED, CARD_DESTROYED, CARD_DISCARDED, 
	CARD_MOVED, CARD_MOVING_AWAY, CARD_PLAY_STARTED, COMBAT_STARTED, TURN_STARTED, TURN_ENDED
	}
	
enum play_space_attributes {
	P1_START_SPACE, P2_START_SPACE, RESOURCE_SPACE, 
}

enum players { P1, P2 }
enum stat_params { LOWEST, HIGHEST, OVER_VALUE, UNDER_VALUE }
enum stats {MAX_ATTACK, MIN_ATTACK, HEALTH, MOVEMENT, TOTAL_COST }
enum turn_stages {
	CARD_PLAYS, END_TURN, START_TURN
}
