extends Node

# All the exisiting cards go into this enum
enum cards {GENERAL_FABRICATION, GORILLA, FANATIC_FOLLOWER, ATTACK_COMMAND, GOOSE, 
	WARTHOG_BERSERKER, 
	GORILLA_BATTLECALLER, SNEK, FOLLOW_PHEROMONES, STAMPEDE, FELOS_EXPEDITIONIST, GORILLA_KING, 
	SKON_INSECT_FATHER, WIZARD_SCOUT, SWITCHEROO, ARCANE_ARROW, MIST_CONJURER, FLOW_ACCELERATOR, 
	EPHEMERAL_ASSASSIN, FIREBALL_SHOOTER, HOMUNCULUS, JELLYFISH_EXTRAORDINAIRE, 
	AUDACIOUS_RESEARCHER, HYRSMIR_RULER_OF_PHYSICS, PSYCHIC_TAKEOVER,  GNOME_PROTECTOR,  
	BOTANO_GARDENER, MORNING_LIGHT, ICE_GOLEM, FIRE_GOLEM, HAIL_STORM, EARTH_GOLEM, 
	PROTECTOR_OF_THE_FOREST, PRANCING_VERDEN, HEART_OF_THE_FOREST, MARCELLA_WHO_NURTURES_GROWTH, 
	VOLCANIC_ERUPTION, FACTORY_WORKER, OBSTRUCTION_CONSTRUCTION, SHOCK_CHARGE, ASSEMBLY_BOT, 
	NETWORK_FEEDER, FURNACE_BOT, EXTERMINATE, PLUG_BUDDY, COMPUTING_BOT, ZOLOI_CHARGER, 
	COPY_MACHINE, ZALOGI_MIND_OF_MACHINES, PLUTO_MUSICAL_GUIDE, MIDAVES_RESEARCHER_OF_LIFE, 
	VOLDOMA_MASTER_OF_ARMS, KILLER_WHALE_BOT, NHOROG_POTION_MASTER, GHENGI_WHO_SHAPES_THE_EARTH, 
	SPOTOS_RECYCLER
}

"""
Current races:
	Felos: Catlike Passion race
	Spotos: Logic/Growth race
	Zoloi: Logic race
	Verder: Growth spirit race
"""


var cards_info = {
	cards.GORILLA: {
		"InGameName": "Gorilla",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 1,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 3, # 3
		"MinAttack": 0, # 0
		"Health": 2, # 2
		"Movement": 1, # 1
		"Lord": false,
		"Purposes": [],
		"Text": "",
		"IMGPath": "res://library/passion/images/Gorilla.png",
	},
	
	cards.FANATIC_FOLLOWER: {
		"InGameName": "Fanatic Follower",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 1,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 1, # 1
		"MinAttack": 0, # 0
		"Health": 3, # 3
		"Movement": 2, # 2
		"Lord": false,
		"Purposes": [Collections.purposes.CONQUER_SPACES],
		"Text": "",
		"IMGPath": "res://library/passion/images/FanaticFollower.png",
	},
	
	cards.ATTACK_COMMAND: {
		"InGameName": "Attack Command",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 1,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"TargetRestrictions": TargetSelection.target_restrictions.OWN_UNITS,
		"Text": "Pick one of your units. Deal damage equal to it's max attack to a unit in range 2.",
		"CardRange": 2,
		"IMGPath": "res://library/passion/images/AttackCommand.png",
	},
	
	cards.GOOSE: {
		"InGameName": "Goose",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 2,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.BATTLE, Collections.purposes.DEFEND_RESOURCE],
		"IMGPath": "res://library/passion/images/Goose.png",
	},
	
	cards.WARTHOG_BERSERKER: {
		"InGameName": "Warthog Berserker",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 3, # 3
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 3,
		"Movement": 2,
		"Lord": false,
		"Text": "Frenzy (move towards the closest enemy unit and attack if possible. Then exhaust)",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://library/passion/images/WarthogBerserker.png",
	},
	
	cards.SNEK: {
		"InGameName": "Snek",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 3, # 3
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "When an opponent unit enters an adjacent space, deal 1 damage to it",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
	
		"IMGPath": "res://library/passion/images/Snek.jpg",
		},
		
	cards.FOLLOW_PHEROMONES: {
		"InGameName": "Follow Pheromones",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 3, # 3
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "Look at the top cards of your deck until you find 2 units. Draw them and put the 
		rest on the bottom of your deck.",
		"IMGPath": "res://library/passion/images/FollowPheromones.png",
	},
	
	cards.GORILLA_BATTLECALLER: {
		"InGameName": "Gorilla Battlecaller",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 4, # 4
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "Add 2 max attack and 1 movement to the units in adjacent spaces",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/passion/images/GorillaBattlecaller.png",
	},
	
	cards.STAMPEDE: {
		"InGameName": "Stampede",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 5, # 5
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "All your units get +2/+2/+2 and +1 movement until your next turn",
		"IMGPath": "res://library/passion/images/Stampede.png",
	},
	
	cards.FELOS_EXPEDITIONIST: {
		"InGameName": "Felos Expeditionist",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 5, # 5
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 5,
		"MinAttack": 3,
		"Health": 6,
		"Movement": 1,
		"Lord": false,
		"Text": "On Attack: Draw a Card",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://library/passion/images/FelosExpeditionist.png",
	},
	
	cards.GORILLA_KING: {
		"InGameName": "GorillaKing",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 6, # 4
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 5,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1, # 1
		"Lord": true,
		"Text": "Your units get +2 max attack for each adjacent unit",
		"Purposes": [],
		"IMGPath": "res://library/passion/images/GorillaKing.png",
	},
	
	cards.SKON_INSECT_FATHER: {
		"InGameName": "S`kon, Insect Father",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION],
		"Costs": {
			Collections.factions.PASSION: 6, # 6
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 5,
		"Movement": 1,
		"Lord": true,
		"Text": "Exhaust: Create a 2m 1/1 <N> Insect fabrication with frenzy, and 'this unit
		deals 1 damage to itself when attacking' in each adjacent space",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
		"IMGPath": "res://library/passion/images/SkonInsectFather.png",
	},
	
	cards.WIZARD_SCOUT: {
		"InGameName": "Wizard Scout",
		"Factions": [Collections.factions.IMAGINATION],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 1, # 1
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 1,
		"MinAttack": 1,
		"Health": 1,
		"Movement": 2,
		"Lord": false,
		"Text": "Exhaust: Swap with one of your own units",
		"Purposes": [],
		"IMGPath": "res://library/imagionation/images/WizardApprentice.png",
	},
	
	cards.SWITCHEROO: {
		"InGameName": "Switcheroo",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.IMAGINATION],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 1,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_UNITS,
		"Text": "Pick two units with the same owner and swap them.",
		"IMGPath": "res://library/imagionation/images/Switcheroo.png",
	},
	
	cards.MIST_CONJURER: {
		"InGameName": "Mist Conjurer",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.IMAGINATION],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 2, # 3
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 1,
		"Movement": 1,
		"Lord": false,
		"Text": "Opponent units in adjacent spaces get -1 Max attack",
		"Purposes": [Collections.purposes.BATTLE, Collections.purposes.DEBUFF_ADJACENT],
		"IMGPath": "res://library/imagionation/images/MistConjurer.png",
	},
	
	cards.ARCANE_ARROW: {
		"InGameName": "Arcane Arrow",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.IMAGINATION],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 2, # 3
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"CardRange": 2,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_UNITS,
		"Text": "Deal 3 damage to a unit",
		"IMGPath": "res://library/imagionation/images/ArcaneArrow.png",
	},
	
	cards.FIREBALL_SHOOTER: {
		"InGameName": "Fireball Shooter",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.IMAGINATION],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 3, # 3
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Purposes": [Collections.purposes.REAR],
		"Lord": false,
		"Text": "Exhaust: deal 1 damage to all enemey units in any direction from this unit",
		"IMGPath": "res://library/imagionation/images/FireballShooter.png",
	},

cards.FLOW_ACCELERATOR: {
		"InGameName": "Flow Accelerator",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.IMAGINATION],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 3, # 3
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "When this unit moves, it gets +1 max attack and health for each space it moved until your next turn",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/imagionation/images/FlowAccelerator.png",
	},
	
	cards.AUDACIOUS_RESEARCHER: {
		"InGameName": "Audacious Researcher",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.IMAGINATION],
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 4,
		"Movement": 1,
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 4, # 4
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"Lord": false,
		"Purposes": [Collections.purposes.BATTLE],
		"Text": "At the start of your turn, if this unit is in a row that's at least halfway towards
		your opponent: draw the top spell in your deck.",
		"IMGPath": "res://library/imagionation/images/AudaciousResearcher.png",
	},
	
	cards.HOMUNCULUS: {
		"InGameName": "Homunculus",
		"Factions": [Collections.factions.IMAGINATION],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 4,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 5,
		"MinAttack": 3,
		"Health": 5,
		"Movement": 1,
		"Lord": false,
		"Purposes": [Collections.purposes.BATTLE],
		"Text": "",
		"IMGPath": "res://library/imagionation/images/Homunculus.png",
	},
	
	cards.EPHEMERAL_ASSASSIN: {
		"InGameName": "Ephemeral Assassin",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.IMAGINATION],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 5,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 6,
		"MinAttack": 2,
		"Health": 3,
		"Movement": 3,
		"Lord": false,
		"Text": "This unit can move through units",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/imagionation/images/EphemeralAssassin.png",
	},
	
	cards.JELLYFISH_EXTRAORDINAIRE: {
		"InGameName": "Jellyfish Extraordinaire",
		"Factions": [Collections.factions.IMAGINATION],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 5, # 5
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 3,
		"Health": 6,
		"Movement": 1,
		"CardFuncs": [],
		"Lord": false,
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
		"Text": "At the start of your turn, if this unit is in a resource space that is not in 
		your starting area, draw a card and add <M>.",
		"IMGPath": "res://library/imagionation/images/JellyfishExtraordinaire.jpg",
	},
	
	cards.HYRSMIR_RULER_OF_PHYSICS: {
		"InGameName": "Hyrsmir, Ruler of Physics",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.IMAGINATION],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 6,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 5,
		"Movement": 1,
		"Lord": true,
		"Text": "At the start of your turn: Swap any number of units any number of times.",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/imagionation/images/HyrsmirRulerOfPhysics.png",
	},
	
	cards.PSYCHIC_TAKEOVER: {
		"InGameName": "Psychic Takeover",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.IMAGINATION],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 6, # 4
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"TargetRestrictions": TargetSelection.target_restrictions.OPPONENT_UNITS,
		"CardRange": 1,
		"Text": "Gain control of an enemy unit",
		"IMGPath": "res://library/imagionation/images/PsychicTakeover.png",
	},
	
	cards.GNOME_PROTECTOR: {
		"InGameName": "Gnome Protector",
		"Factions": [Collections.factions.GROWTH],
		"CardType": Collections.card_types.UNIT,
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 2,
		"Movement": 1,
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 1, # 1
			Collections.factions.LOGIC: 0,
		},
		"Lord": false,
		"Text": "Your units in adjacent spaces have +1 health",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/growth/images/GnomeProtector.png",
	},
	cards.MORNING_LIGHT: {
		"InGameName": "Morning Light",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 1, # 1
			Collections.factions.LOGIC: 0,
		},
		"CardRange": 0,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_UNITS,
		"Text": "Target unit gets 2 health and +1 movement.",
		"IMGPath": "res://library/growth/images/MorningLight.jpg",
	},
	
	cards.BOTANO_GARDENER: {
		"CardType": Collections.card_types.UNIT,
		"InGameName": "Botano Gardener",
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 2,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 2,
		"Movement": 1,
		"Purposes": [Collections.purposes.REAR],
		"Lord": false,
		"Text": "Exhaust: Add 1 min attack and 1 health to an adjacent unit",
		"IMGPath": "res://library/growth/images/BotanoGardener.png",
	},
	
	cards.FIRE_GOLEM: {
		"InGameName": "Fire Golem",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 3, # 3
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 2, # 1
		"MinAttack": 1, # 1
		"Health": 3, # 3
		"Movement": 1, # 1
		"Lord": false,
		"Text": "Exhaust: This unit deals damage equal to it's min attack to each enemy unit in a range 
		of 2",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://library/growth/images/FireGolem.jpg",
	},
	
	cards.HAIL_STORM: {
		"InGameName": "Hail Storm",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 3, # 3
			Collections.factions.LOGIC: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "Select a 3 x 3 square at range 1. All units in that square get -1/-0 and -1 movement.",
		"IMGPath": "res://library/growth/images/HailStorm.jpg",
	},
	
	cards.ICE_GOLEM: {
		"InGameName": "Ice Golem",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 3, # 4
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 5,
		"Movement": 1, # 1
		"Lord": false,
		"Text": "When Ice Golem deals damage to a unit, that unit gets -1/-0 and -1 movement until
		your next turn",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://library/growth/images/IceGolem.jpg",
	},
	
	cards.EARTH_GOLEM: {
		"InGameName": "Earth Golem",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 4,
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 2,
		"Health": 7,
		"Movement": 1,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://library/growth/images/EarthGolem.png",
	},
	
	cards.PROTECTOR_OF_THE_FOREST: {
		"InGameName": "Protector of the Forest",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 4, # 6
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 4,
		"Movement": 1,
		"Lord": false,
		"Text": "At the start of your turn: If Protector didn't move since your last turn, it gets +2 health",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://library/growth/images/ProtectorOfTheForest.jpg",
	},

	cards.HEART_OF_THE_FOREST: {
		"InGameName": "Heart of the Forest",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 5, # 8
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 0,
		"MinAttack": 0,
		"Health": 8,
		"Movement": 0,
		"Lord": false,
		"Text": "Allied units in range 1 get +0/+4. Units in range 2 get +0/+2",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/growth/images/HeartOfTheForest.jpg",
	},
	
	cards.VOLCANIC_ERUPTION: {
		"InGameName": "Volcanic Eruption",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 5, # 4
			Collections.factions.LOGIC: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "Select a 4 x 4 square at range 1. Deal 2 damage to each enemy unit in the selected 
		square.",
		"IMGPath": "res://library/growth/images/VolcanicEruption.jpg",
	},
	
	cards.PRANCING_VERDEN: {
		"InGameName": "Prancing Verden",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 6, # 6
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 2,
		"Health": 3,
		"Movement": 4,
		"Lord": false,
		"Text": "This unit can move through units. If it moves through a friendly unit, that unit
		gets +2 movement and +1 min attack this turn.",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/growth/images/PrancingVerden.jpg",
	},
	
	cards.MARCELLA_WHO_NURTURES_GROWTH: {
		"InGameName": "Marcella, Who Nurtures Growth",
		"CardType": Collections.card_types.UNIT,		
		"Factions": [Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 6, # 8
			Collections.factions.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 3,
		"Health": 7,
		"Movement": 1,
		"Lord": true,
		"Text": "Pay 2<N>: Draw a card, add 1 min attack and 1 health to up to one adjacent unit",
		"Purposes": [Collections.purposes.REAR,],
		"IMGPath": "res://library/growth/images/MarcellaWhoNurturesGrowth.png",
	},
	
	cards.ASSEMBLY_BOT: {
		"InGameName": "Assembly Bot",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 1,
		},
		"MaxAttack": 1,
		"MinAttack": 0,
		"Health": 1,
		"Movement": 1,
		"Lord": false,
		"Text": "When this unit enters battle, create a 1/1 logic fabrication in an adjacent space
		with 1 movement",
		"Purposes": [],
		"IMGPath": "res://library/logic/images/AssemblyBot.png",
	},
	
	cards.OBSTRUCTION_CONSTRUCTION: {
		"InGameName": "Obstruction Construction",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 1,
		},
		"MaxAttack": 0,
		"MinAttack": 0,
		"Health": 4,
		"Movement": 1,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
		"IMGPath": "res://library/logic/images/ObstructionConstruction.png",
	},
	
	cards.SHOCK_CHARGE: {
		"InGameName": "Shock Charge",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 1,
		},
		"Text": "Refresh up to two units.",
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"IMGPath": "res://library/logic/images/ShockCharge.jpg",
	},
	
	cards.FACTORY_WORKER: {
		"InGameName": "Factory Worker",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 2,
		},
		"MaxAttack": 2,
		"MinAttack": 0,
		"Health": 3,
		"Movement": 1,
		"Purposes": [Collections.purposes.REAR],
		"Lord": false,
		"Text": "Exhaust: Add 1 R",
		"IMGPath": "res://library/logic/images/FactoryWorker.png",
	},
	
	cards.NETWORK_FEEDER: {
		"InGameName": "Network Feeder",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 3,
		},
		"MaxAttack": 1,
		"MinAttack": 1,
		"Health": 2,
		"Movement": 1,
		"Lord": false,
		"Text": "This unit gets 2 max attack and 2 health for each adjacent allied unit",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://library/logic/images/NetworkFeeder.jpg",
	},
	
	cards.EXTERMINATE: {
		"InGameName": "Exterminate",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 3, # 3
		},
		"Text": "Consume one of your own units: Destroy a unit within range 1 of the consumed unit",
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.OWN_UNITS,
		"IMGPath": "res://library/logic/images/Exterminate.jpg",
	
	},
	
	cards.FURNACE_BOT: {
		"InGameName": "Furnace Bot",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 4, # 2
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 4,
		"Movement": 2,
		"Lord": false,
		"Text": "Consume a unit in range 1: This unit gets +2 max attack, min attack and health",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://library/logic/images/FurnaceBot.jpg",
	},
	
	cards.ZOLOI_CHARGER: {
		"InGameName": "Zoloi Charger",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 4, # 6
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 5,
		"Movement": 1,
		"Lord": false,
		"Text": "If there's a unit to the left and right of this unit at the start of your turn, this unit gets +3 max attack, Impact and +2 movement until your next turn",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/logic/images/ZoloiCharger.png",
	},
	
	cards.PLUG_BUDDY: {
		"InGameName": "Plug Buddy",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 5, # 5
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "Exhaust, 2<R>: Refresh all your other units in range 1",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/logic/images/PlugBuddy.jpg",
	},
	
	cards.COMPUTING_BOT: {
		"InGameName": "Computing Bot",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 5, # 4
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 6,
		"Lord": false,
		"Movement": 1,
		"Text": "Exhaust, 1<R>: Consume a unit in range 1: Discard 1 card and draw 3 cards",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/logic/images/ComputingBot.jpg",
	},
	
	cards.COPY_MACHINE: {
		"InGameName": "Copy Machine",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 6, # 7
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 5,
		"Movement": 1,
		"Lord": false,
		"Text": "Exhaust, 3<R>: Choose a unit in range 1. Create a fabrication that's a copy of that
		unit in range 1. Exhaust it.",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/logic/images/CopyMachine.png",
	},
	
	cards.ZALOGI_MIND_OF_MACHINES: {
		"InGameName": "Zalogi, Mind Of Machines",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 6, # 7
		},
		"MaxAttack": 6,
		"MinAttack": 4,
		"Health": 7,
		"Movement": 1,
		"Lord": true,
		"Text": "Your fabrications are created with +2 max attack, min attack and health and +1 movement",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/logic/images/ZalogiMindOfMachines.png",
	},
	
	cards.PLUTO_MUSICAL_GUIDE: {
		"InGameName": "Pluto, Musical Guide",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION, Collections.factions.IMAGINATION],
		"Costs": {
			Collections.factions.PASSION: 2,
			Collections.factions.IMAGINATION: 3,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 0,
		},
		"Attack": 4,
		"Health": 4,
		"Movement": 2,
		"Lord": true,
		"Text": "Exhaust: Choose a creature that attacks twice this turn",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.factions.PASSION: 0,
				Collections.factions.IMAGINATION: 0,
				Collections.factions.GROWTH: 0,
				Collections.factions.LOGIC: 0,
			},
			"FuncName": "attack_twice",
			"FuncText": "Attack twice",
			"RequiresActivation": true,
			"Trigger": Collections.triggers.CARD_ACTIVATION,
			"EffectArguments": {"NumberOfUnits": 1}
		}],
		"UnitRequirements": [],
		"AIUnitHints": [],
		"IMGName": "PlutoMusicalGuide",
	},
	cards.MIDAVES_RESEARCHER_OF_LIFE: {
		"InGameName": "Midaves, Researcher of Life",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION, Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 1,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 3,
			Collections.factions.LOGIC: 0,
		},
		"Attack": 3,
		"Health": 5,
		"Movement": 1,
		"Lord": true,
		"Text": "Exhaust: Grow 1. If the unit you´ve grown attacks this turn, cycle 1",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.factions.PASSION: 0,
				Collections.factions.IMAGINATION: 0,
				Collections.factions.GROWTH: 0,
				Collections.factions.LOGIC: 0,
			},
			"FuncName": "jip_func",
			"FuncText": "Grow 1",
			"RequiresActivation": true,
			"Trigger": Collections.triggers.CARD_ACTIVATION,
			"EffectArguments": {}
		}],
		"UnitRequirements": [],
		"AIUnitHints": [],
		"IMGName": "MidavesResearcherOfLife",
	},
	cards.KILLER_WHALE_BOT: {
		"InGameName": "Killer Whale Bot",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.PASSION, Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 3,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 1,
		},
		"Attack": 5,
		"Health": 3,
		"Movement": 2,
		"Lord": false,
		"Text": "Fight",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.factions.PASSION: 0,
				Collections.factions.IMAGINATION: 0,
				Collections.factions.GROWTH: 0,
				Collections.factions.LOGIC: 0,
			},
			"FuncName": "fight",
			"FuncText": "Fight",
			"RequiresActivation": true,
			"Trigger": Collections.triggers.CARD_ACTIVATION,
			"EffectArguments": {}
		}],
		"UnitRequirements": [],
		"AIUnitHints": [],
		"IMGName": "KillerWhaleBot",
	},
	cards.NHOROG_POTION_MASTER: {
		"InGameName": "Nhorog, Potion Master",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.IMAGINATION, Collections.factions.GROWTH],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 2,
			Collections.factions.GROWTH: 2,
			Collections.factions.LOGIC: 0,
		},
		"Attack": 2,
		"Health": 3,
		"Movement": 1,
		"Lord": true,
		"Text": "Exhaust: Grow 2, then deal 2 damage",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.factions.PASSION: 0,
				Collections.factions.IMAGINATION: 1,
				Collections.factions.GROWTH: 1,
				Collections.factions.LOGIC: 0,
			},
			"FuncName": "grow_and_deal_damage",
			"FuncText": "Grow and deal damage",
			"RequiresActivation": true,
			"Trigger": Collections.triggers.CARD_ACTIVATION,
			"EffectArguments": {}
		}],
		"UnitRequirements": [],
		"AIUnitHints": [],
		"IMGName": "NhorogPotionMaster",
	},
	cards.VOLDOMA_MASTER_OF_ARMS: {
		"InGameName": "Voldoma, Master of Arms",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.IMAGINATION, Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 2,
			Collections.factions.GROWTH: 0,
			Collections.factions.LOGIC: 2,
		},
		"Attack": 3,
		"Health": 3,
		"Movement": 3,
		"Lord": true,
		"Text": "Battle\n Exhaust: Deal 3 damage",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.factions.PASSION: 0,
				Collections.factions.IMAGINATION: 1,
				Collections.factions.GROWTH: 1,
				Collections.factions.LOGIC: 0,
			},
			"FuncName": "deal_damage",
			"FuncText": "Deal 3 damage",
			"RequiresActivation": true,
			"Trigger": Collections.triggers.CARD_ACTIVATION,
			"EffectArguments": {"Damage": 3}
		}],
		"AIUnitHints": [],
		"UnitRequirements": ["only_battle"],
		"IMGName": "VoldomaMasterOfArms",
	},
	cards.GHENGI_WHO_SHAPES_THE_EARTH: {
		"InGameName": "Ghengi, Who Shapes The Earth",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.GROWTH, Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 1,
			Collections.factions.LOGIC: 1,
		},
		"Attack": 2,
		"Health": 2,
		"Movement": 1,
		"Lord": true,
		"Text": "You may use resources of any faction to pay for cards and abilities",
		"CardFuncs": [{
			"ActiveFunc": false,
			"Costs": {
				Collections.factions.PASSION: 0,
				Collections.factions.IMAGINATION: 0,
				Collections.factions.GROWTH: 0,
				Collections.factions.LOGIC: 0,
			},
			"FuncName": "ignore_factions_for_resources",
			"FuncText": "Ignore factions for resources",
			"RequiresActivation": false,
			"Trigger": -1,
			"EffectArguments": {}
		}],
		"UnitRequirements": [],
		"AIUnitHints": ["prefer_resource"],
		"IMGName": "GhengiWhoShapesTheEarth",
	},
	cards.SPOTOS_RECYCLER: {
		"InGameName": "Spotos Recycler",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.GROWTH, Collections.factions.LOGIC],
		"Costs": {
			Collections.factions.PASSION: 0,
			Collections.factions.IMAGINATION: 0,
			Collections.factions.GROWTH: 2,
			Collections.factions.LOGIC: 2,
		},
		"Attack": 2,
		"Health": 2,
		"Movement": 1,
		"Lord": false,
		"Text": "When one of your units dies, grow 2",
		"CardFuncs": [{
			"ActiveFunc": false,
			"Costs": {
				Collections.factions.PASSION: 0,
				Collections.factions.IMAGINATION: 0,
				Collections.factions.GROWTH: 0,
				Collections.factions.LOGIC: 0,
			},
			"FuncName": "grow",
			"FuncText": "Grow 2",
			"RequiresActivation": false,
			"EffectArguments": {"GrowthValue": 2}
		}],
		"UnitRequirements": [],
		"IMGName": "SpotosRecycler",
	},
}


func get_card_class(card_index: int) -> Variant:
	var card: Variant
	match card_index:

		## Passion ###

		cards.GORILLA:
			card = Gorilla
		cards.FANATIC_FOLLOWER:
			card = FanaticFollower
		cards.ATTACK_COMMAND:
			card = AttackCommand
		cards.WARTHOG_BERSERKER:
			card = WarthogBerserker
		cards.GOOSE:
			card = Goose
		cards.SNEK:
			card = Snek
		cards.GORILLA_BATTLECALLER:
			card = GorillaBattlecaller
		cards.FOLLOW_PHEROMONES:
			card = FollowPheromones
		cards.GORILLA_KING:
			card = GorillaKing
		cards.FELOS_EXPEDITIONIST:
			card = FelosExpeditionist
		cards.SKON_INSECT_FATHER:
			card = SkonInsectFather
		cards.STAMPEDE:
			card = Stampede
#
		#### Imagination ###
#
		cards.WIZARD_SCOUT:
			card = WizardScout
		cards.SWITCHEROO:
			card = Switcheroo
		cards.EPHEMERAL_ASSASSIN:
			card = EphemeralAssassin
		cards.MIST_CONJURER:
			card = MistConjurer
		cards.FIREBALL_SHOOTER:
			card = FireballShooter
		cards.HOMUNCULUS:
			card = Homunculus
		cards.JELLYFISH_EXTRAORDINAIRE:
			card = JellyfishExtraordinaire
		cards.AUDACIOUS_RESEARCHER:
			card = AudaciousResearcher
		cards.HYRSMIR_RULER_OF_PHYSICS:
			card = HyrsmirRulerOfPhysics
		cards.FLOW_ACCELERATOR:
			card = FlowAccelerator
		cards.ARCANE_ARROW:
			card = ArcaneArrow
		#cards.PSYCHIC_TAKEOVER:
			#card = PsychicTakeover
#
		#### Growth ###
#
		cards.GNOME_PROTECTOR:
			card = GnomeProtector
		cards.BOTANO_GARDENER:
			card = BotanoGardener
		cards.MORNING_LIGHT:
			card = MorningLight
		cards.ICE_GOLEM:
			card = IceGolem
		cards.FIRE_GOLEM:
			card = FireGolem
		cards.HAIL_STORM:
			card = HailStorm
		cards.EARTH_GOLEM:
			card = EarthGolem
		cards.PROTECTOR_OF_THE_FOREST:
			card = ProtectorOfTheForest
		cards.PRANCING_VERDEN:
			card = PrancingVerden
		cards.HEART_OF_THE_FOREST:
			card = HeartOfTheForest
		cards.MARCELLA_WHO_NURTURES_GROWTH:
			card = MarcellaWhoNurturesGrowth
		cards.VOLCANIC_ERUPTION:
			card = VolcanicEruption
		#
		#### Logic ###
#
		cards.ASSEMBLY_BOT:
			card = AssemblyBot
		cards.OBSTRUCTION_CONSTRUCTION:
			card = ObstructionConstruction
		cards.SHOCK_CHARGE:
			card = ShockCharge
		cards.FACTORY_WORKER:
			card = FactoryWorker
		cards.NETWORK_FEEDER:
			card = NetworkFeeder
		cards.FURNACE_BOT:
			card = FurnaceBot
		cards.EXTERMINATE:
			card = Exterminate
		cards.PLUG_BUDDY:
			card = PlugBuddy
		cards.COMPUTING_BOT:
			card = ComputingBot
		cards.ZOLOI_CHARGER:
			card = ZoloiCharger
		cards.COPY_MACHINE:
			card = CopyMachine
		cards.ZALOGI_MIND_OF_MACHINES:
			card = ZalogiMindOfMachines
	return card
