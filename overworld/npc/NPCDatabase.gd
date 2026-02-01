extends Node

enum npcs {
	### START_OF_JOURNEY ###
	ALPHONSO,
	BETTY,
	GAMZA,
	WISE_MAN,
	### PASSION_LEVEL_1 ###
	TRUDY,
	RAMBO,
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
}
enum character_types {
	BEEBOY,
	BUMBLEBEE_LADY,
	BUSINESS_CAP_BOY,
	DINO_BUSINESS_MAN,
	ROBOT_GUY,
	JESUS,
	GARY,
	GURU_1,
	GURU_2,
	GURU_3,
	GURU_LAGHIMA,
	SHALLAN,
	BUSINESS_PERSON_1,
	BUSINESS_PERSON_2,
	BUSINESS_PERSON_3,
	BILL_GATES,
	WISE_MAN,
	GENERIC_GUY_1,
	GENERIC_GUY_2,
	GENERIC_GUY_3,
	GENERIC_GIRL_1,
	GENERIC_GIRL_2,
	GENERIC_GIRL_3,
}
enum special_rules {
	ADD_1_MAX_ATTACK,
	ADD_1_HEALTH,
	IMAGINATION_SPELLS_1_CHEAPER,
	CREATE_ROBOT_FABRICATION,
}

var npc_data: Dictionary = {
	### START_OF_JOURNEY ###
	npcs.WISE_MAN:
	{
		"Name": "Wise Man",
		"Dialogue": ["Would you like to try another starter deck? Or unlock all cards?"],
		"QuestionOptions": {
			"Passion": {
				"Text": "Change deck to Passion",
				"Func": func() : DeckSetup.change_deck_to_passion()
			}, 
			"Imagination": {
				"Text": "Change deck to Imagination",
				"Func": func() : DeckSetup.change_deck_to_imagination()
			},
			"Growth": {
				"Text": "Change deck to Growth",
				"Func": func() : DeckSetup.change_deck_to_growth()
			},
			"Logic": {
				"Text": "Change deck to Logic",
				"Func": func() : DeckSetup.change_deck_to_logic()
			},
			"AllCards": {
				"Text": "Unlock all cards",
				"Func": func() : DeckSetup.unlock_all_cards()
			},
			"Exit": {
				"Text": "Exit",
				"Func": func() : OverworldManager.set_can_move_to_true()
			}
		},
		"Battle": false,
		"PlayCards": false,
		"CharacterModel": character_types.WISE_MAN,
	},
	npcs.ALPHONSO:
	{
		"Name": "Alphonso",
		"Dialogue": ["Let's go nerd."],
		"QuestionOptions": [],
		"Battle": true,
		"StartingUnits": {},
		"BossCard": BossCardDatabase.boss_cards.FANATIC_LEADER,
		"PlayCards": false,
		"DeckID": DeckCollection.deck_ids.CONQUER_AND_HOLD,
		"CharacterModel": character_types.GENERIC_GUY_1,
	},
	npcs.BETTY:
	{
		"Name": "Betty",
		"Dialogue": ["Round 2, here we go!"],
		"QuestionOptions": [],
		"Battle": true,
		"StartingUnits": {},
		"DeckID": DeckCollection.deck_ids.IMAGINARY_FRIENDS,
		"BossCard": BossCardDatabase.boss_cards.REALITY_BENDER,
		"PlayCards": false,
		"CharacterModel": character_types.GENERIC_GIRL_2,
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
		"PlayCards": false,
		"CharacterModel": character_types.GENERIC_GIRL_1,
	},
	### PASION_LEVEL_1 ###
	npcs.TRUDY:
	{
		"Name": "Trudy",
		"Dialogue": ["You think you can handle me?", "My gorillas will fucking tear you to shreds"],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GIRL_1,
		"DeckID": DeckCollection.deck_ids.CONQUER_AND_HOLD
	},
	npcs.RAMBO:
	{
		"Name": "Rambo",
		"Dialogue": ["Can you shut up? I'm watching TV."],
		"QuestionOptions": [],
		"Battle": false,
		"CharacterModel": character_types.GENERIC_GUY_1,
	},
	npcs.INGRID:
	{
		"Name": "Ingrid",
		"Dialogue": ["I don't care"],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GIRL_2,
		"DeckID": DeckCollection.deck_ids.BIG_ATTACK,
	},
	npcs.YAYA:
	{
		"Name": "Ingrid",
		"Dialogue": ["It's all the same."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GIRL_3,
		"DeckID": DeckCollection.deck_ids.STAY_AWAY,
	},
	### START_OF_PASSION ###
	npcs.HANS:
	{
		"Name": "Hans",
		"Dialogue": ["You think you can handle me?", "My gorillas will fucking tear you to shreds"],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.BEEBOY,
		"DeckID": DeckCollection.deck_ids.GOTTA_GO_FAST,
	},
	npcs.MASHA:
	{
		"Name": "Masha",
		"Dialogue": ["WOOF! WOOF!"],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.BUMBLEBEE_LADY,
		"DeckID": DeckCollection.deck_ids.FRENZY_START
	},
	npcs.JACQUES:
	{
		"Name": "Jacques",
		"Dialogue": ["Ew, what's that smell?", "Oh, it's me."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.DINO_BUSINESS_MAN,
		"DeckID": DeckCollection.deck_ids.SMELLY_JACQUES,
	},
	npcs.GARY:
	{
		"Name": "Gary",
		"Dialogue": ["Bring it on bitch"],
		"QuestionOptions": [],
		"SpecialRules": [special_rules.ADD_1_MAX_ATTACK],
		"Battle": true,
		"CharacterModel": character_types.GARY,
		"DeckID": DeckCollection.deck_ids.GARY,
	},
	### START OF IMAGINATION ###
	npcs.STUDENT_DAL:
	{
		"Name": "Student Dal",
		"Dialogue": ["Boom, baby!"],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.BEEBOY,
		"DeckID": DeckCollection.deck_ids.IMAGINATION_MISSILES
	},
	npcs.STUDENT_MAC:
	{
		"Name": "Student Mac",
		"Dialogue": ["When I grow up I want to be a dinosaur."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.DINO_BUSINESS_MAN,
		"DeckID": DeckCollection.deck_ids.MOVEMENT_SHENANIGANS
	},
	npcs.STUDENT_KALA:
	{
		"Name": "Student Kala",
		"Dialogue": ["I wonder if aliens can see sounds?"],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.BUMBLEBEE_LADY,
		"DeckID": DeckCollection.deck_ids.SPELL_SLINGERS
	},
	npcs.SHALLAN:
	{
		"Name": "Shallan",
		"Dialogue": ["If you open your mind, anything is possible."],
		"QuestionOptions": [],
		"SpecialRules": [special_rules.IMAGINATION_SPELLS_1_CHEAPER],
		"Battle": true,
		"CharacterModel": character_types.SHALLAN,
		"DeckID": DeckCollection.deck_ids.IMAGINATION_MISSILES
	},
	### IMAGINATION_LEVEL_1 ###
	npcs.ADOLIN:
	{
		"Name": "Adolin",
		"Dialogue": ["Welcome to the party!"],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GUY_2,
		"DeckID": DeckCollection.deck_ids.FLOW_AND_INSPIRE
	},
	
	npcs.KALADIN:
	{
		"Name": "Kaladin",
		"Dialogue": ["I will protect those who cannot protect themselves."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GUY_1,
		"DeckID": DeckCollection.deck_ids.SPELLS_WHAT_ELSE,
	},
	
	npcs.DALINAR:
	{
		"Name": "Kaladin",
		"Dialogue": ["Journey before destination. It cannot be a journey if it doesn't have a beginning."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GUY_3,
		"DeckID": DeckCollection.deck_ids.TAKE_OVER,
	},
	
	### GROWTH_LEVEL_1 ###
	npcs.KWIK:
	{
		"Name": "Kwik",
		"Dialogue": ["Relax, take it easy."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GIRL_3,
		"DeckID": DeckCollection.deck_ids.PATIENCE,
	},
	npcs.KWEK:
	{
		"Name": "KWEK",
		"Dialogue": ["This stuff is fire!"],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GUY_1,
		"DeckID": DeckCollection.deck_ids.FIRE,
	},
	npcs.KWAK:
	{
		"Name": "Kwak",
		"Dialogue": ["If you think nature is slow, wait until you see my wind elementals!"],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GIRL_1,
		"DeckID": DeckCollection.deck_ids.FAST_GNOMES,
	},
	### START_OF_GROWTH ###
	npcs.GURU_FLAPPIE:
	{
		"Name": "Guru Flappie",
		"Dialogue": ["I'm just really into my guitar right now."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GURU_1,
		"DeckID": DeckCollection.deck_ids.BEEFY_BOYS,
	},
	npcs.GURU_KAL:
	{
		"Name": "Guru Kal",
		"Dialogue": ["I'm studying to become a guru."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GURU_2,
		"DeckID": DeckCollection.deck_ids.GOLEMS,
	},
	npcs.GURU_TRONG:
	{
		"Name": "Guru Trong",
		"Dialogue": ["Right now right now!"],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.GURU_3,
		"DeckID": DeckCollection.deck_ids.ELEMENTS,
	},
	npcs.GURU_LAGHIMA:
	{
		"Name": "Guru Laghima",
		"Dialogue": ["Let go your earthly tether.", "Enter the void.", "Empty and become wind."],
		"QuestionOptions": [],
		"SpecialRules": [special_rules.ADD_1_HEALTH],
		"Battle": true,
		"CharacterModel": character_types.GURU_LAGHIMA,
		"DeckID": DeckCollection.deck_ids.GURU_LAGHIMA,
	},
	### START_OF_LOGIC ###
	npcs.BUSINESS_PERSON_LEONARDO:
	{
		"Name": "Businessperson Leonardo",
		"Dialogue": ["It's all about the grind."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.BUSINESS_PERSON_1,
		"DeckID": DeckCollection.deck_ids.LOGIC_FACTORY,
	},
	npcs.BUSINESS_PERSON_ANA:
	{
		"Name": "Businessperson Ana",
		"Dialogue": ["I'm too old for this shit."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.BUSINESS_PERSON_2,
		"DeckID": DeckCollection.deck_ids.RESOURCE_EXTRAVAGANZA,
	},
	npcs.BUSINESS_PERSON_JEROEN:
	{
		"Name": "Businessperson Jeroen",
		"Dialogue": ["Life is one big party."],
		"QuestionOptions": [],
		"Battle": true,
		"CharacterModel": character_types.BUSINESS_PERSON_3,
		"DeckID": DeckCollection.deck_ids.STRENGTH_IN_NUMBERS,
	},
	npcs.BILL_GATES:
	{
		"Name": "Bill Gates",
		"Dialogue": ["Success is a lousy teacher."],
		"QuestionOptions": [],
		"Battle": true,
		"SpecialRules": [special_rules.CREATE_ROBOT_FABRICATION],
		"CharacterModel": character_types.BILL_GATES,
		"DeckID": DeckCollection.deck_ids.BILL_GATES,
	},
}

var character_model := {
	character_types.BEEBOY: "beeboy",
	character_types.BUMBLEBEE_LADY: "bumblebee_lady",
	character_types.BUSINESS_CAP_BOY: "business_cap_boy",
	character_types.DINO_BUSINESS_MAN: "dino_business_man",
	character_types.GARY: "gary",
	character_types.ROBOT_GUY: "robot_guy",
	character_types.JESUS: "jesus",
	character_types.GURU_1: "guru_1",
	character_types.GURU_2: "guru_2",
	character_types.GURU_3: "guru_3",
	character_types.BUSINESS_PERSON_1: "business_person_1",
	character_types.BUSINESS_PERSON_2: "business_person_2",
	character_types.BUSINESS_PERSON_3: "business_person_3",
	character_types.BILL_GATES: "bill_gates",
	character_types.GURU_LAGHIMA: "guru_laghima",
	character_types.SHALLAN: "shallan",
	character_types.WISE_MAN: "wise_man",
	character_types.GENERIC_GUY_1: "generic_guy_1",
	character_types.GENERIC_GUY_2: "generic_guy_2",
	character_types.GENERIC_GUY_3: "generic_guy_3",
	character_types.GENERIC_GIRL_1: "generic_girl_1",
	character_types.GENERIC_GIRL_2: "generic_girl_2",
	character_types.GENERIC_GIRL_3: "generic_girl_3",
}


func setup_special_rules(special_rule_id: int) -> void:
	match special_rule_id:
		special_rules.ADD_1_MAX_ATTACK:
			await SpecialRules.add_stat(Collections.stats.MAX_ATTACK, 1)
		special_rules.ADD_1_HEALTH:
			await SpecialRules.add_1_health_end_of_turn()
		special_rules.IMAGINATION_SPELLS_1_CHEAPER:
			await SpecialRules.make_imagination_spells_1_cheaper()
		special_rules.CREATE_ROBOT_FABRICATION:
			await SpecialRules.create_robot_fabrication_end_of_turn()


func npc_animation(npc: int, direction: int, animation_type: int) -> String:
	var character_type: String
	var direction_string: String
	var animation_type_string: String

	character_type = character_model[npc_data[npc]["CharacterModel"]]

	match direction:
		Collections.directions.UP:
			direction_string = "back"
		Collections.directions.RIGHT:
			direction_string = "side"
		Collections.directions.LEFT:
			direction_string = "side"
		Collections.directions.DOWN:
			direction_string = "front"

	match animation_type:
		Collections.animation_types.IDLE:
			animation_type_string = "idle"
		Collections.animation_types.WALKING:
			animation_type_string = "walk"

	return str(character_type, "_", direction_string, "_", animation_type_string)
