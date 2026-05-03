extends Node


enum normal_opponents {
	EASY_DEFENDER,
}

var normal_opponent_info := {
	
	normal_opponents.EASY_DEFENDER: {
		"Class": EasyDefender,
		"InGameName": "Easy Defender",
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
