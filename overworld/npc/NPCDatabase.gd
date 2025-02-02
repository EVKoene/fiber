extends Node


enum npcs {
	### START_OF_JOURNEY ###
	WISE_MAN,
	
	### PASSION_LEVEL_1 ###
	TRUDY, RAMBO, INGRID, YAYA,
	
	### START_OF_PASSION ###
	HANS, MASHA, JACQUES, GARY, 
	
	### START_OF_IMAGINATION ###
	STUDENT_DAL, STUDENT_MAC, STUDENT_KALA, SHALLAN, 
	
	### GROWTH_LEVEL_1 ###
	KWIK, KWEK, KWAK,
	
	### START_OF_GROWTH ###
	GURU_KAL, GURU_LAGHIMA, GURU_FLAPPIE, GURU_TRONG, 
	
	### START_OF_LOGIC ###
	BUSINESS_PERSON_LEONARDO, BUSINESS_PERSON_ANA, BUSINESS_PERSON_JEROEN, BILL_GATES, 
}
enum character_types {
	BEEBOY, BUMBLEBEE_LADY, BUSINESS_CAP_BOY, DINO_BUSINESS_MAN, ROBOT_GUY, JESUS, GARY, GURU_1,
	GURU_2, GURU_3, GURU_LAGHIMA, SHALLAN, BUSINESS_PERSON_1, BUSINESS_PERSON_2, BUSINESS_PERSON_3,
	BILL_GATES, WISE_MAN, GENERIC_GUY_1, GENERIC_GUY_2, GENERIC_GUY_3, GENERIC_GIRL_1, 
	GENERIC_GIRL_2, GENERIC_GIRL_3,
}
enum special_rules { 
	ADD_1_MAX_ATTACK, ADD_1_HEALTH, IMAGINATION_SPELLS_1_CHEAPER, 
	CREATE_ROBOT_FABRICATION, 
}


var npc_data: Dictionary = {
	### PASION_LEVEL_1 ###
	
	npcs.TRUDY: {
		"Name": "Trudy",
		"Dialogue": ["You think you can handle me?", "My gorillas will fucking tear you to shreds"],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GIRL_1,
		"DeckID": DeckCollection.deck_ids.GORILLA
	},
	
	npcs.RAMBO: {
		"Name": "Rambo",
		"Dialogue": ["Can you shut up? I'm watching TV."],
		"Battle": false,
		"CharacterModel": character_types.GENERIC_GUY_1,
	},
	
	npcs.INGRID: {
		"Name": "Ingrid",
		"Dialogue": ["I don't care"],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GIRL_2,
		"DeckID": DeckCollection.deck_ids.BIG_ATTACK,
	},
	
	npcs.YAYA: {
		"Name": "Ingrid",
		"Dialogue": ["It's all the same."],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GIRL_3,
		"DeckID": DeckCollection.deck_ids.STAY_AWAY,
	},
	
	### START_OF_PASSION ###
	npcs.HANS: {
		"Name": "Hans",
		"Dialogue": ["You think you can handle me?", "My gorillas will fucking tear you to shreds"],
		"Battle": true,
		"CharacterModel": character_types.BEEBOY,
		"DeckID": DeckCollection.deck_ids.GOTTA_GO_FAST,
	},
	npcs.MASHA: {
		"Name": "Masha",
		"Dialogue": ["WOOF! WOOF!"],
		"Battle": true,
		"CharacterModel": character_types.BUMBLEBEE_LADY,
		"DeckID": DeckCollection.deck_ids.FRENZY_START
	},
	npcs.JACQUES: {
		"Name": "Jacques",
		"Dialogue": ["Ew, what's that smell?", "Oh, it's me."],
		"Battle": true,
		"CharacterModel": character_types.DINO_BUSINESS_MAN,
		"DeckID": DeckCollection.deck_ids.SMELLY_JACQUES,
	},
	
	npcs.GARY: {
		"Name": "Gary",
		"Dialogue": ["Bring it on bitch"],
		"SpecialRules": [special_rules.ADD_1_MAX_ATTACK],
		"Battle": true,
		"CharacterModel": character_types.GARY,
		"DeckID": DeckCollection.deck_ids.GARY,
	},
	
	### START OF IMAGINATION ###
	npcs.STUDENT_DAL: {
		"Name": "Student Dal",
		"Dialogue": ["Boom, baby!"],
		"Battle": true,
		"CharacterModel": character_types.BEEBOY,
		"DeckID": DeckCollection.deck_ids.IMAGINATION_MISSILES
	},
	
	npcs.STUDENT_MAC: {
		"Name": "Student Mac",
		"Dialogue": ["When I grow up I want to be a dinosaur."],
		"Battle": true,
		"CharacterModel": character_types.DINO_BUSINESS_MAN,
		"DeckID": DeckCollection.deck_ids.MOVEMENT_SHENANIGANS
	},
	
	npcs.STUDENT_KALA: {
		"Name": "Student Kala",
		"Dialogue": ["I wonder if aliens can see sounds?"],
		"Battle": true,
		"CharacterModel": character_types.BUMBLEBEE_LADY,
		"DeckID": DeckCollection.deck_ids.SPELL_SLINGERS
	},
	
	npcs.SHALLAN: {
		"Name": "Shallan",
		"Dialogue": ["If you open your mind, anything is possible"],
		"SpecialRules": [special_rules.IMAGINATION_SPELLS_1_CHEAPER],
		"Battle": true,
		"CharacterModel": character_types.SHALLAN,
		"DeckID": DeckCollection.deck_ids.IMAGINATION_MISSILES
	},
	
	### GROWTH_LEVEL_1 ###
	
	npcs.KWIK: {
		"Name": "Kwik",
		"Dialogue": ["Relax, take it easy."],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GIRL_3,
		"DeckID": DeckCollection.deck_ids.PATIENCE,
	},
	
	npcs.KWEK: {
		"Name": "KWEK",
		"Dialogue": ["This stuff is fire!"],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GUY_1,
		"DeckID": DeckCollection.deck_ids.FIRE,
	},
	
	npcs.KWAK: {
		"Name": "Kwak",
		"Dialogue": ["If you think nature is slow, wait until you see my wind elementals!"],
		"Battle": true,
		"CharacterModel": character_types.GENERIC_GIRL_1,
		"DeckID": DeckCollection.deck_ids.FAST_GNOMES,
	},
	
	### START_OF_GROWTH ###
	
	npcs.GURU_FLAPPIE: {
		"Name": "Guru Flappie",
		"Dialogue": ["I'm just really into my guitar right now."],
		"Battle": true,
		"CharacterModel": character_types.GURU_1,
		"DeckID": DeckCollection.deck_ids.BEEFY_BOYS,
	},
	
	npcs.GURU_KAL: {
		"Name": "Guru Kal",
		"Dialogue": ["I'm studying to become a guru."],
		"Battle": true,
		"CharacterModel": character_types.GURU_2,
		"DeckID": DeckCollection.deck_ids.GOLEMS,
	},
	
	npcs.GURU_TRONG: {
		"Name": "Guru Trong",
		"Dialogue": ["Right now right now!"],
		"Battle": true,
		"CharacterModel": character_types.GURU_3,
		"DeckID": DeckCollection.deck_ids.ELEMENTS,
	},
	
	npcs.GURU_LAGHIMA: {
		"Name": "Guru Laghima",
		"Dialogue": ["Let go your earthly tether.", "Enter the void.", "Empty and become wind."],
		"SpecialRules": [special_rules.ADD_1_HEALTH],
		"Battle": true,
		"CharacterModel": character_types.GURU_LAGHIMA,
		"DeckID": DeckCollection.deck_ids.GURU_LAGHIMA,
	},
	
	### START_OF_LOGIC ###
	
	npcs.BUSINESS_PERSON_LEONARDO: {
		"Name": "Businessperson Leonardo",
		"Dialogue": ["It's all about the grind."],
		"Battle": true,
		"CharacterModel": character_types.BUSINESS_PERSON_1,
		"DeckID": DeckCollection.deck_ids.LOGIC_FACTORY,
	},
	
	npcs.BUSINESS_PERSON_ANA: {
		"Name": "Businessperson Ana",
		"Dialogue": ["I'm too old for this shit."],
		"Battle": true,
		"CharacterModel": character_types.BUSINESS_PERSON_2,
		"DeckID": DeckCollection.deck_ids.RESOURCE_EXTRAVAGANZA,
	},
	
	npcs.BUSINESS_PERSON_JEROEN: {
		"Name": "Businessperson Jeroen",
		"Dialogue": ["Life is one big party."],
		"Battle": true,
		"CharacterModel": character_types.BUSINESS_PERSON_3,
		"DeckID": DeckCollection.deck_ids.STRENGTH_IN_NUMBERS,
	},
	
	npcs.BILL_GATES: {
		"Name": "Bill Gates",
		"Dialogue": ["Success is a lousy teacher."],
		"Battle": true,
		"SpecialRules": [special_rules.CREATE_ROBOT_FABRICATION],
		"CharacterModel": character_types.BILL_GATES,
		"DeckID": DeckCollection.deck_ids.BILL_GATES,
	},
	
	### START_OF_JOURNEY ###
	npcs.WISE_MAN: {
		"Name": "Wise Man",
		"Dialogue": ["Good luck."],
		"Battle": false,
		"CharacterModel": character_types.WISE_MAN,
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
