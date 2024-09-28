extends Node

### CARD ###
enum factions {ANIMAL, MAGIC, NATURE, ROBOT,}
var all_factions: Array = [factions.ANIMAL, factions.MAGIC, factions.NATURE, factions.ROBOT]
var faction_names: Dictionary = {
	factions.ANIMAL: "Animal",
	factions.MAGIC: "Magic",
	factions.NATURE: "Nature",
	factions.ROBOT: "Robot",
	}
enum card_types {SPELL, UNIT}
enum stat_params { LOWEST, HIGHEST, OVER_VALUE, UNDER_VALUE }
enum stats {MAX_ATTACK, MIN_ATTACK, HEALTH, MOVEMENT, TOTAL_COST }


### BATTLE ###
var turn_stage_names: Dictionary = {
		turn_stages.CARD_PLAYS: "CardPlays", 
		turn_stages.END_TURN: "EndTurn", 
		turn_stages.START_TURN:"StartTurn",
}
enum triggers {
	ATTACK, ATTACK_FINISHED, CARD_ACTIVATION, CARD_CREATED, CARD_DESTROYED, CARD_DISCARDED, 
	CARD_MOVED, CARD_MOVING_AWAY, CARD_PLAY_STARTED, COMBAT_STARTED, TURN_STARTED, TURN_ENDED
	}
enum play_space_attributes {
	P1_START_SPACE, P2_START_SPACE, RESOURCE_SPACE, 
}


### AI HELPER ###
enum purposes {
	BUFF_ADJACENT, DEFEND_RESOURCE, BATTLE, REAR, DEBUFF_ADJACENT,
}
enum hint_types {NECESSARY, SUFFICIENT}
enum turn_stages {
	CARD_PLAYS, END_TURN, START_TURN
}


### MULTI PURPOSE ###
enum directions {DOWN, LEFT, RIGHT, UP}
enum players { P1, P2 }


### OVERWORLD ###
enum character_types { BEEBOY, BUSINESS_CAP_BOY, ROBOT_GUY, }
enum animation_types { IDLE, WALKING }
