extends Node


enum boss_cards {
	FANATIC_LEADER
}

var boss_cards_info := {
	
	boss_cards.FANATIC_LEADER: {
		"InGameName": "Fanatic Leader",
		"fibers": [Collections.fibers.PASSION],
		"AttackRange": 1,
		"MaxAttack": 4,
		"Class": FanaticLeader,
		"MinAttack": 1,
		"Health": 15,
		"Movement": 1,
		"IMGPath": "res://assets/card_images/passion/FanaticLeader.png"
	},
}
