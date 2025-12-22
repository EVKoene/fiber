extends Node


enum boss_cards {
	FANATIC_LEADER,
	REALITY_BENDER,
	ZAIA,
}

var boss_cards_info := {
	
	boss_cards.FANATIC_LEADER: {
		"Class": FanaticLeader,
		"InGameName": "Fanatic Leader",
		"fibers": [Collections.fibers.PASSION],
		"AttackRange": 1,
		"MaxAttack": 4,
		"MinAttack": 1,
		"Health": 15,
		"Movement": 1,
		"IMGPath": "res://assets/card_images/passion/FanaticLeader.png"
	},
	
	boss_cards.REALITY_BENDER: {
		"Class": RealityBender,
		"InGameName": "Reality Bender",
		"fibers": [Collections.fibers.IMAGINATION],
		"AttackRange": 2,
		"MaxAttack": 3,
		"MinAttack": 2,
		"Health": 15,
		"Movement": 2,
		"IMGPath": "res://assets/card_images/imagination/RealityBender.png"
	},
	
	boss_cards.ZAIA: {
		"Class": Zaia,
		"InGameName": "Zaia",
		"fibers": [Collections.fibers.GROWTH],
		"AttackRange": 2,
		"MaxAttack": 4,
		"MinAttack": 4,
		"Health": 20,
		"Movement": 0,
		"IMGPath": "res://assets/card_images/growth/Zaia.png"
	},
}
