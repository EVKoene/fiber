extends Node

enum npcs {
	### START_OF_JOURNEY ###
	ALPHONSO,
	BETTY,
	GAMZA,
	WISE_MAN,
	### PASSION_LEVEL_1 ###
	TRUDY,
	INGRID,
	YAYA,
	### START_OF_PASSION ###
	HANS,
	MASHA,
	JACQUES,
	GARY,
	### IMAGINATION_LEVEL_1 ###
	ADOLIN,
	KALADIN,
	DALINAR,
	### START_OF_IMAGINATION ###
	STUDENT_DAL,
	STUDENT_MAC,
	STUDENT_KALA,
	SHALLAN,
	### GROWTH_LEVEL_1 ###
	KWIK,
	KWEK,
	KWAK,
	### START_OF_GROWTH ###
	GURU_KAL,
	GURU_LAGHIMA,
	GURU_FLAPPIE,
	GURU_TRONG,
	### START_OF_LOGIC ###
	BUSINESS_PERSON_LEONARDO,
	BUSINESS_PERSON_ANA,
	BUSINESS_PERSON_JEROEN,
	BILL_GATES,
	
	### NEW_STYLE ###
	EASY_DEFENDER,
	FIRESTORM
}

var npc_data: Dictionary = {
	### START_OF_JOURNEY ###
	npcs.ALPHONSO:
	{
		"Name": "Alphonso",
		"Dialogue": ["Let's go nerd."],
		"Battle": true,
		"StartingUnits": {},
		"BossCard": BossCardDatabase.boss_cards.FANATIC_LEADER,
		"NormalOpponent": null,
		"PlayCards": false,
		"DeckID": DeckCollection.deck_ids.CONQUER_AND_HOLD,
	},
	npcs.BETTY:
	{
		"Name": "Betty",
		"Dialogue": ["Round 2, here we go!"],
		"Battle": true,
		"StartingUnits": {},
		"DeckID": DeckCollection.deck_ids.IMAGINARY_FRIENDS,
		"BossCard": BossCardDatabase.boss_cards.REALITY_BENDER,
		"NormalOpponent": null,
		"PlayCards": false,
	},
	npcs.GAMZA:
	{
		"Name": "Gamza",
		"Dialogue": ["Your adventure stops with me."],
		"QuestionOptions": [],
		"Battle": true,
		"StartingUnits": {
			0: {
				"CardIndex": CardDatabase.cards.WIND_GOLEM,
				"Column": 0,
				"Row": 3
			},
			1: {
				"CardIndex": CardDatabase.cards.WIND_GOLEM,
				"Column": 8,
				"Row": 3
			}
		},
		"DeckID": DeckCollection.deck_ids.LOGIC_FACTORY,
		"BossCard": BossCardDatabase.boss_cards.ZAIA,
		"NormalOpponent": null,
		"PlayCards": false,
	},
	npcs.EASY_DEFENDER:
	{
		"Name": "Easy Defender",
		"Dialogue": [""],
		"StartingUnits": {},
		"QuestionOptions": [],
		"Battle": true,
		"BossCard": -1,
		"NormalOpponent": EasyDefender,
		"PlayCards": false,
		"DeckID": DeckCollection.deck_ids.LOGIC_FACTORY,
	},
	npcs.FIRESTORM:
	{
		"Name": "FireStorm",
		"Dialogue": [""],
		"StartingUnits": {},
		"QuestionOptions": [],
		"Battle": true,
		"BossCard": -1,
		"NormalOpponent": FireStorm,
		"PlayCards": false,
		"DeckID": DeckCollection.deck_ids.LOGIC_FACTORY,
	},
	### PASION_LEVEL_1 ###
	npcs.TRUDY:
	{
		"Name": "Trudy",
		"Dialogue": ["You think you can handle me?", "My gorillas will fucking tear you to shreds"],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.CONQUER_AND_HOLD
	},
	npcs.INGRID:
	{
		"Name": "Ingrid",
		"Dialogue": ["I don't care"],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.BIG_ATTACK,
	},
	npcs.YAYA:
	{
		"Name": "Ingrid",
		"Dialogue": ["It's all the same."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.STAY_AWAY,
	},
	### START_OF_PASSION ###
	npcs.HANS:
	{
		"Name": "Hans",
		"Dialogue": ["You think you can handle me?", "My gorillas will fucking tear you to shreds"],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.GOTTA_GO_FAST,
	},
	npcs.MASHA:
	{
		"Name": "Masha",
		"Dialogue": ["WOOF! WOOF!"],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.FRENZY_START
	},
	npcs.JACQUES:
	{
		"Name": "Jacques",
		"Dialogue": ["Ew, what's that smell?", "Oh, it's me."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.SMELLY_JACQUES,
	},
	npcs.GARY:
	{
		"Name": "Gary",
		"Dialogue": ["Bring it on bitch"],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.GARY,
	},
	### START OF IMAGINATION ###
	npcs.STUDENT_DAL:
	{
		"Name": "Student Dal",
		"Dialogue": ["Boom, baby!"],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.IMAGINATION_MISSILES
	},
	npcs.STUDENT_MAC:
	{
		"Name": "Student Mac",
		"Dialogue": ["When I grow up I want to be a dinosaur."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.MOVEMENT_SHENANIGANS
	},
	npcs.STUDENT_KALA:
	{
		"Name": "Student Kala",
		"Dialogue": ["I wonder if aliens can see sounds?"],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.SPELL_SLINGERS
	},
	npcs.SHALLAN:
	{
		"Name": "Shallan",
		"Dialogue": ["If you open your mind, anything is possible."],
		"QuestionOptions": [],
		"DeckID": DeckCollection.deck_ids.IMAGINATION_MISSILES
	},
	### IMAGINATION_LEVEL_1 ###
	npcs.ADOLIN:
	{
		"Name": "Adolin",
		"Dialogue": ["Welcome to the party!"],
		"QuestionOptions": [],
		"DeckID": DeckCollection.deck_ids.FLOW_AND_INSPIRE
	},
	
	npcs.KALADIN:
	{
		"Name": "Kaladin",
		"Dialogue": ["I will protect those who cannot protect themselves."],
		"QuestionOptions": [],
		"DeckID": DeckCollection.deck_ids.SPELLS_WHAT_ELSE,
	},
	
	npcs.DALINAR:
	{
		"Name": "Kaladin",
		"Dialogue": ["Journey before destination. It cannot be a journey if it doesn't have a beginning."],
		"QuestionOptions": [],
		"DeckID": DeckCollection.deck_ids.TAKE_OVER,
	},
	
	### GROWTH_LEVEL_1 ###
	npcs.KWIK:
	{
		"Name": "Kwik",
		"Dialogue": ["Relax, take it easy."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.PATIENCE,
	},
	npcs.KWEK:
	{
		"Name": "KWEK",
		"Dialogue": ["This stuff is fire!"],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.FIRE,
	},
	npcs.KWAK:
	{
		"Name": "Kwak",
		"Dialogue": ["If you think nature is slow, wait until you see my wind elementals!"],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.FAST_GNOMES,
	},
	### START_OF_GROWTH ###
	npcs.GURU_FLAPPIE:
	{
		"Name": "Guru Flappie",
		"Dialogue": ["I'm just really into my guitar right now."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.BEEFY_BOYS,
	},
	npcs.GURU_KAL:
	{
		"Name": "Guru Kal",
		"Dialogue": ["I'm studying to become a guru."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.GOLEMS,
	},
	npcs.GURU_TRONG:
	{
		"Name": "Guru Trong",
		"Dialogue": ["Right now right now!"],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.ELEMENTS,
	},
	npcs.GURU_LAGHIMA:
	{
		"Name": "Guru Laghima",
		"Dialogue": ["Let go your earthly tether.", "Enter the void.", "Empty and become wind."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.GURU_LAGHIMA,
	},
	### START_OF_LOGIC ###
	npcs.BUSINESS_PERSON_LEONARDO:
	{
		"Name": "Businessperson Leonardo",
		"Dialogue": ["It's all about the grind."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.LOGIC_FACTORY,
	},
	npcs.BUSINESS_PERSON_ANA:
	{
		"Name": "Businessperson Ana",
		"Dialogue": ["I'm too old for this shit."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.RESOURCE_EXTRAVAGANZA,
	},
	npcs.BUSINESS_PERSON_JEROEN:
	{
		"Name": "Businessperson Jeroen",
		"Dialogue": ["Life is one big party."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.STRENGTH_IN_NUMBERS,
	},
	npcs.BILL_GATES:
	{
		"Name": "Bill Gates",
		"Dialogue": ["Success is a lousy teacher."],
		"QuestionOptions": [],
		"Battle": false,
		"DeckID": DeckCollection.deck_ids.BILL_GATES,
	},
}
