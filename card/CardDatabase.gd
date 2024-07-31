extends Node

# All the exisiting cards go into this enum
enum cards {GENERAL_FABRICATION, GORILLA, ATTACK_COMMAND, GOOSE, WARTHOG_BERSERKER, GORILLA_BATTLECALLER, SNEK,
FOLLOW_PHEROMONES, RHINOCEROS, STAMPEDE, FELOS_EXPEDITIONIST, SKON_INSECT_FATHER, WIZARD_SCOUT, 
SWITCHEROO, ARCANE_ARROW, MIST_CONJURER, FLOW_ACCELERATOR, EPHEMERAL_ASSASSIN, FIREBALL_SHOOTER, 
HOMUNCULUS, JELLYFISH_EXTRAORDINAIRE, AUDACIOUS_RESEARCHER, HYRSMIR_RULER_OF_PHYSICS, 
PSYCHIC_TAKEOVER,  GNOME_PROTECTOR,  BOTANO_GARDENER, MORNING_LIGHT, ICE_GOLEM, FIRE_GOLEM, 
HAIL_STORM, EARTH_GOLEM, PROTECTOR_OF_THE_FOREST, PRANCING_VERDEN, HEART_OF_THE_FOREST, 
MARCELLA_WHO_NURTURES_GROWTH, VOLCANIC_ERUPTION, FACTORY_WORKER, 
OBSTRUCTION_CONSTRUCTION, SHOCK_CHARGE, ASSEMBLY_BOT, NETWORK_FEEDER, FURNACE_BOT, EXTERMINATE, 
PLUG_BUDDY, COMPUTING_BOT, ZOLOI_CHARGER, COPY_MACHINE, ZALOGI_MIND_OF_MACHINES, 
PLUTO_MUSICAL_GUIDE, MIDAVES_RESEARCHER_OF_LIFE, VOLDOMA_MASTER_OF_ARMS, KILLER_WHALE_BOT, 
NHOROG_POTION_MASTER, GHENGI_WHO_SHAPES_THE_EARTH, SPOTOS_RECYCLER
}

"""
Current races:
	Felos: Catlike Animal race
	Spotos: Robot/Nature race
	Zoloi: Robot race
	Verder: Nature spirit race
"""


var cards_info = {
	cards.GORILLA: {
		"InGameName": "Gorilla",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 1,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 3, # 3
		"MinAttack": 0, # 0
		"Health": 2, # 2
		"Movement": 1, # 1
		"Lord": false,
		"Purposes": [],
		"Text": "",
		"IMGPath": "res://library/animal/images/Gorilla.png",
	},
	
	cards.ATTACK_COMMAND: {
		"InGameName": "Attack Command",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 1,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"TargetRestrictions": TargetSelection.target_restrictions.OWN_UNITS,
		"Text": "Pick one of your units. Deal damage equal to it's max attack to a unit in range 2.
		Add 1 <A>",
		"CardRange": 2,
		"IMGPath": "res://library/animal/images/AttackCommand.png",
	},
	
	cards.GOOSE: {
		"InGameName": "Goose",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 2,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.BATTLE, Collections.purposes.DEFEND_RESOURCE],
		"IMGPath": "res://library/animal/images/Goose.png",
	},
	
	cards.WARTHOG_BERSERKER: {
		"InGameName": "WarthogBerserker",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 3, # 3
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 3,
		"Movement": 2,
		"Lord": false,
		"Text": "Frenzy (move towards the closest enemy unit and attack if possible. Then exhaust)",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://library/animal/images/WarthogBerserker.png",
	},
	
	cards.SNEK: {
		"InGameName": "Snek",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 3, # 3
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "When an opponent unit enters an adjacent space, deal 1 damage to it",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
	
		"IMGPath": "res://library/animal/images/Snek.jpg",
		},
	
	cards.GORILLA_BATTLECALLER: {
		"InGameName": "Gorilla Battlecaller",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 4, # 4
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "Add 2 max attack and 1 movement to the units in adjacent spaces",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/animal/images/GorillaBattlecaller.png",
	},
	
	cards.FOLLOW_PHEROMONES: {
		"InGameName": "Follow Pheromones",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 3, # 3
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "Look at the top cards of your deck until you find 2 units. Draw them and put the 
		rest on the bottom of your deck.",
		"IMGPath": "res://library/animal/images/FollowPheromones.png",
	},
	
	cards.RHINOCEROS: {
		"InGameName": "Rhinoceros",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 4, # 4
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 5,
		"Movement": 10, # 10
		"Lord": false,
		"Text": "Can only move in a straight line without stopping. If this unit moves 2 or more before attacking, will deal 1 damage to defending unit and 1 damage to itself",
		"Purposes": [],
		"IMGPath": "res://library/animal/images/Rhinoceros.png",
	},
	
	cards.STAMPEDE: {
		"InGameName": "Stampede",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 5, # 5
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "All your units get +2/+2/+2 and +1 movement until your next turn",
		"IMGPath": "res://library/animal/images/Stampede.png",
	},
	
	cards.FELOS_EXPEDITIONIST: {
		"InGameName": "Felos Expeditionist",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 5, # 5
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 5,
		"MinAttack": 3,
		"Health": 6,
		"Movement": 1,
		"Lord": false,
		"Text": "On Attack: Draw a Card",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://library/animal/images/FelosExpeditionist.png",
	},
	
	cards.SKON_INSECT_FATHER: {
		"InGameName": "S`kon, Insect Father",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ANIMAL],
		"Costs": {
			Collections.factions.ANIMAL: 6, # 6
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 5,
		"Movement": 1,
		"Lord": true,
		"Text": "Exhaust: Create a 2m 1/1 <N> Insect fabrication with frenzy, and 'this unit
		deals 1 damage to itself when attacking' in each adjacent space",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
		"IMGPath": "res://library/animal/images/SkonInsectFather.png",
	},
	
	cards.WIZARD_SCOUT: {
		"InGameName": "Wizard Scout",
		"Factions": [Collections.factions.MAGIC],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 1, # 1
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 1,
		"Movement": 2,
		"Lord": false,
		"Text": "Exhaust: Swap with one of your own units",
		"Purposes": [],
		"IMGPath": "res://library/magic/images/WizardApprentice.png",
	},
	
	cards.SWITCHEROO: {
		"InGameName": "Switcheroo",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.MAGIC],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 1,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_UNITS,
		"Text": "Pick two units with the same owner and swap them. Add 1 <M>",
		"IMGPath": "res://library/magic/images/Switcheroo.png",
	},
	
	cards.ARCANE_ARROW: {
		"InGameName": "Arcane Arrow",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.MAGIC],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 3, # 3
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"CardRange": 2,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_UNITS,
		"Text": "Deal 3 damage to a unit",
		"IMGPath": "res://library/magic/images/ArcaneArrow.png",
	},
	
	cards.MIST_CONJURER: {
		"InGameName": "Mist Conjurer",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.MAGIC],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 3, # 3
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 2,
		"Movement": 1,
		"Lord": false,
		"Text": "Opponent units in adjacent spaces get -2 Max attack",
		"Purposes": [Collections.purposes.BATTLE, Collections.purposes.DEBUFF_ADJACENT],
		"IMGPath": "res://library/magic/images/MistConjurer.png",
	},

cards.FLOW_ACCELERATOR: {
		"InGameName": "Flow Accelerator",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.MAGIC],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 3, # 3
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "When this unit moves, it gets +1 max attack and health for each space it moved until your next turn",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/magic/images/FlowAccelerator.png",
	},
	
	cards.EPHEMERAL_ASSASSIN: {
		"InGameName": "Ephemeral Assassin",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.MAGIC],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 4, # 2
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 3,
		"Health": 3,
		"Movement": 3,
		"Lord": false,
		"Text": "This unit can move through units",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/magic/images/EphemeralAssassin.png",
	},

	cards.FIREBALL_SHOOTER: {
		"InGameName": "Fireball Shooter",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.MAGIC],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 4, # 3
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Purposes": [Collections.purposes.REAR],
		"Lord": false,
		"Text": "Exhaust: deal 1 damage to all units in any direction from this unit",
		"IMGPath": "res://library/magic/images/FireballShooter.png",
	},
	
	cards.HOMUNCULUS: {
		"InGameName": "Homunculus",
		"Factions": [Collections.factions.MAGIC],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 3,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"Attack": 4,
		"Health": 4,
		"Movement": 1,
		"Lord": false,
		"Purposes": [Collections.purposes.BATTLE],
		"Text": "",
		"IMGPath": "res://library/magic/images/Homunculus.png",
	},
	
	cards.AUDACIOUS_RESEARCHER: {
		"InGameName": "Audacious Researcher",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.MAGIC],
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 4,
		"Movement": 1,
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 4, # 4
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"Lord": false,
		"Purposes": [Collections.purposes.BATTLE],
		"Text": "At the start of your turn, if this unit is in a row that's at least halfway towards
		your opponent: draw the top spell in your deck.",
		"IMGPath": "res://library/magic/images/AudaciousResearcher.png",
	},
	
	cards.JELLYFISH_EXTRAORDINAIRE: {
		"InGameName": "Jellyfish Extraordinaire",
		"Factions": [Collections.factions.MAGIC],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 5, # 5
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
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
		"IMGPath": "res://library/magic/images/JellyfishExtraordinaire.jpg",
	},
	
	cards.HYRSMIR_RULER_OF_PHYSICS: {
		"InGameName": "Hyrsmir, Ruler of Physics",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.MAGIC],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 4,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"Attack": 2,
		"Health": 5,
		"Movement": 1,
		"Lord": true,
		"Text": "At the start of your turn: Swap any number of units any number of times.",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/magic/images/HyrsmirRulerOfPhysics.png",
	},
	
	cards.PSYCHIC_TAKEOVER: {
		"InGameName": "Psychic Takeover",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.MAGIC],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 4, # 4
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"TargetRestrictions": TargetSelection.target_restrictions.OPPONENT_UNITS,
		"CardRange": 1,
		"Text": "Gain control of an enemy unit",
		"IMGPath": "res://library/magic/images/PsychicTakeover.png",
	},
	
	cards.GNOME_PROTECTOR: {
		"InGameName": "Gnome Protector",
		"Factions": [Collections.factions.NATURE],
		"CardType": Collections.card_types.UNIT,
		"Attack": 1,
		"Health": 2,
		"Movement": 1,
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 1, # 1
			Collections.factions.ROBOT: 0,
		},
		"Lord": false,
		"Text": "Your units in adjacent spaces have +1 health",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/nature/images/GnomeProtector.png",
	},
	
	cards.BOTANO_GARDENER: {
		"CardType": Collections.card_types.UNIT,
		"InGameName": "Botano Gardener",
		"Factions": [Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 1,
			Collections.factions.ROBOT: 0,
		},
		"Attack": 1,
		"Health": 1,
		"Movement": 1,
		"Purposes": [Collections.purposes.REAR],
		"Lord": false,
		"Text": "Exhaust: Add +1/+1 to an adjacent unit",
		"IMGPath": "res://library/nature/images/BotanoGardener.png",
	},
	
	cards.MORNING_LIGHT: {
		"InGameName": "Morning Light",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 1, # 1
			Collections.factions.ROBOT: 0,
		},
		"CardRange": 0,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "Target unit gets +0/+3 and +1 movement. Add 1 <N>",
		"IMGPath": "res://library/nature/images/MorningLight.jpg",
	},
	
	cards.HAIL_STORM: {
		"InGameName": "Hail Storm",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 2, # 2
			Collections.factions.ROBOT: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "Select a 3 x 3 square at range 1. Deal 1 damage to each enemy unit in the selected 
		square. Those units get -1/-0 and -1 movement.",
		"IMGPath": "res://library/nature/images/HailStorm.jpg",
	},
	
	cards.ICE_GOLEM: {
		"InGameName": "Ice Golem",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 2, # 2
			Collections.factions.ROBOT: 0,
		},
		"Attack": 1,
		"Health": 3,
		"Movement": 1, # 1
		"Lord": false,
		"Text": "When Ice Golem deals damage to a unit, that unit gets -1/-0 and -1 movement until
		your next turn",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://library/nature/images/IceGolem.jpg",
	},
	
	cards.FIRE_GOLEM: {
		"InGameName": "Fire Golem",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 2, # 2
			Collections.factions.ROBOT: 0,
		},
		"Attack": 1, # 1
		"Health": 3, # 3
		"Movement": 1, # 1
		"Lord": false,
		"Text": "Exhaust: This unit deals damage equal to it's attack to each enemy unit in a range 
		of 2",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://library/nature/images/FireGolem.jpg",
	},
	
	cards.EARTH_GOLEM: {
		"InGameName": "Earth Golem",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 3,
			Collections.factions.ROBOT: 0,
		},
		"Attack": 2,
		"Health": 8,
		"Movement": 1,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://library/nature/images/EarthGolem.png",
	},
	
	cards.PROTECTOR_OF_THE_FOREST: {
		"InGameName": "Protector of the Forest",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 3, # 3
			Collections.factions.ROBOT: 0,
		},
		"Attack": 3,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "At the start of your turn: If Protector didn't move since your last turn, it gets
		+0/+2",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://library/nature/images/ProtectorOfTheForest.jpg",
	},
	
	cards.PRANCING_VERDEN: {
		"InGameName": "Prancing Verden",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.NATURE],
		"Attack": 3,
		"Health": 3,
		"Movement": 5,
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 3, # 3
			Collections.factions.ROBOT: 0,
		},
		"Lord": false,
		"Text": "This unit can move through units. If it moves through a friendly unit, that unit
		gets +2 movement and +1 attack this turn.",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/nature/images/PrancingVerden.jpg",
	},

	cards.HEART_OF_THE_FOREST: {
		"InGameName": "Heart of the Forest",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.NATURE],
		"Attack": 0,
		"Health": 8,
		"Movement": 0,
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 4, # 4
			Collections.factions.ROBOT: 0,
		},
		"Lord": false,
		"Text": "Allied units in range 1 get +0/+4. Units in range 2 get +0/+2",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/nature/images/HeartOfTheForest.jpg",
	},
	
	cards.MARCELLA_WHO_NURTURES_GROWTH: {
		"InGameName": "Marcella, Who Nurtures Growth",
		"CardType": Collections.card_types.UNIT,		
		"Factions": [Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 4, # 4
			Collections.factions.ROBOT: 0,
		},
		"Attack": 3,
		"Health": 5,
		"Movement": 1,
		"Lord": true,
		"Text": "Pay 2<N>: Draw a card, give an adjacent unit +1/+1",
		"Purposes": [Collections.purposes.REAR,],
		"IMGPath": "res://library/nature/images/MarcellaWhoNurturesGrowth.png",
	},
	
	cards.VOLCANIC_ERUPTION: {
		"InGameName": "Volcanic Eruption",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 4, # 4
			Collections.factions.ROBOT: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "Select a 4 x 4 square at range 1. Deal 2 damage to each enemy unit in the selected 
		square.",
		"IMGPath": "res://library/nature/images/HailStorm.jpg",
	},
	
	cards.ASSEMBLY_BOT: {
		"InGameName": "Assembly Bot",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 1,
		},
		"Attack": 1,
		"Health": 1,
		"Movement": 1,
		"Lord": false,
		"Text": "When this unit enters battle, create a 1/1 robot fabrication in an adjacent space
		with 1 movement",
		"Purposes": [],
		"IMGPath": "res://library/robot/images/AssemblyBot.png",
	},
	cards.OBSTRUCTION_CONSTRUCTION: {
		"InGameName": "Obstruction Construction",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 1,
		},
		"Attack": 0,
		"Health": 4,
		"Movement": 1,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
		"IMGPath": "res://library/robot/images/ObstructionConstruction.png",
	},
	
	cards.SHOCK_CHARGE: {
		"InGameName": "Shock Charge",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 1,
		},
		"Text": "Refresh up to two units. Add 1 <R>",
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"IMGPath": "res://library/robot/images/ShockCharge.jpg",
	},
	
	cards.FACTORY_WORKER: {
		"InGameName": "Factory Worker",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 2,
		},
		"Attack": 1,
		"Health": 3,
		"Movement": 1,
		"Purposes": [Collections.purposes.REAR],
		"Lord": false,
		"Text": "Exhaust: Add 1 R",
		"IMGPath": "res://library/robot/images/FactoryWorker.png",
	},
	
	cards.NETWORK_FEEDER: {
		"InGameName": "Network Feeder",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 2,
		},
		"Attack": 1,
		"Health": 1,
		"Movement": 1,
		"Lord": false,
		"Text": "This unit gets +2/+2 for each adjacent allied unit",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://library/robot/images/NetworkFeeder.jpg",
	},
	
	cards.FURNACE_BOT: {
		"InGameName": "Furnace Bot",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 2, # 2
		},
		"Attack": 1,
		"Health": 2,
		"Movement": 2,
		"Lord": false,
		"Text": "Consume a unit in range 1: This unit gets +2 attack and health",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://library/robot/images/FurnaceBot.jpg",
	},
	
	cards.EXTERMINATE: {
		"InGameName": "Exterminate",
		"CardType": Collections.card_types.SPELL,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 3, # 3
		},
		"Text": "Consume one of your own units: Destroy a unit within range 2 of the consumed unit",
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.OWN_UNITS,
		"IMGPath": "res://library/robot/images/Exterminate.jpg",
	
	},
	
	cards.PLUG_BUDDY: {
		"InGameName": "Plug Buddy",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 3, # 3
		},
		"Attack": 2,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "Exhaust, 1<R>: Refresh all your other units in range 2",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/robot/images/PlugBuddy.jpg",
	},
	
	cards.ZOLOI_CHARGER: {
		"InGameName": "Zoloi Charger",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0, # 3
		},
		"Attack": 3,
		"Health": 4,
		"Movement": 1,
		"Lord": false,
		"Text": "If at the start of your turn there are units in two adjacent spaces on opposite 
		sides of this unit, This unit gets +3/+0, Impact and +2 movement until your next turn",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://library/robot/images/ZoloiCharger.png",
	},
	
	cards.COMPUTING_BOT: {
		"InGameName": "Computing Bot",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 4, # 4
		},
		"Attack": 4,
		"Health": 4,
		"Lord": false,
		"Movement": 1,
		"Text": "Exhaust: Consume a unit in range 2: Discard 1 card and draw 3 cards",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/robot/images/ComputingBot.jpg",
	},
	
	cards.COPY_MACHINE: {
		"InGameName": "Copy Machine",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0, # 3
		},
		"Attack": 2,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "Exhaust: Choose a unit in range 1. Create a fabrication that's a copy of that
		unit in range 1. Exhaust it.",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/robot/images/CopyMachine.png",
	},
	
	cards.ZALOGI_MIND_OF_MACHINES: {
		"InGameName": "Zalogi, Mind Of Machines",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 4, # 4
		},
		"Attack": 3,
		"Health": 4,
		"Movement": 1,
		"Lord": true,
		"Text": "Fabrications are created with +2/+2",	
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://library/robot/images/ZalogiMindOfMachines.png",
	},
	cards.PLUTO_MUSICAL_GUIDE: {
		"InGameName": "Pluto, Musical Guide",
		"CardType": Collections.card_types.UNIT,
		"Factions": [Collections.factions.ANIMAL, Collections.factions.MAGIC],
		"Costs": {
			Collections.factions.ANIMAL: 2,
			Collections.factions.MAGIC: 3,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 0,
		},
		"Attack": 4,
		"Health": 4,
		"Movement": 2,
		"Lord": true,
		"Text": "Exhaust: Choose a creature that attacks twice this turn",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.factions.ANIMAL: 0,
				Collections.factions.MAGIC: 0,
				Collections.factions.NATURE: 0,
				Collections.factions.ROBOT: 0,
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
		"Factions": [Collections.factions.ANIMAL, Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 1,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 3,
			Collections.factions.ROBOT: 0,
		},
		"Attack": 3,
		"Health": 5,
		"Movement": 1,
		"Lord": true,
		"Text": "Exhaust: Grow 1. If the unit you´ve grown attacks this turn, cycle 1",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.factions.ANIMAL: 0,
				Collections.factions.MAGIC: 0,
				Collections.factions.NATURE: 0,
				Collections.factions.ROBOT: 0,
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
		"Factions": [Collections.factions.ANIMAL, Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 3,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 1,
		},
		"Attack": 5,
		"Health": 3,
		"Movement": 2,
		"Lord": false,
		"Text": "Fight",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.factions.ANIMAL: 0,
				Collections.factions.MAGIC: 0,
				Collections.factions.NATURE: 0,
				Collections.factions.ROBOT: 0,
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
		"Factions": [Collections.factions.MAGIC, Collections.factions.NATURE],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 2,
			Collections.factions.NATURE: 2,
			Collections.factions.ROBOT: 0,
		},
		"Attack": 2,
		"Health": 3,
		"Movement": 1,
		"Lord": true,
		"Text": "Exhaust: Grow 2, then deal 2 damage",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.factions.ANIMAL: 0,
				Collections.factions.MAGIC: 1,
				Collections.factions.NATURE: 1,
				Collections.factions.ROBOT: 0,
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
		"Factions": [Collections.factions.MAGIC, Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 2,
			Collections.factions.NATURE: 0,
			Collections.factions.ROBOT: 2,
		},
		"Attack": 3,
		"Health": 3,
		"Movement": 3,
		"Lord": true,
		"Text": "Battle\n Exhaust: Deal 3 damage",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.factions.ANIMAL: 0,
				Collections.factions.MAGIC: 1,
				Collections.factions.NATURE: 1,
				Collections.factions.ROBOT: 0,
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
		"Factions": [Collections.factions.NATURE, Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 1,
			Collections.factions.ROBOT: 1,
		},
		"Attack": 2,
		"Health": 2,
		"Movement": 1,
		"Lord": true,
		"Text": "You may use resources of any faction to pay for cards and abilities",
		"CardFuncs": [{
			"ActiveFunc": false,
			"Costs": {
				Collections.factions.ANIMAL: 0,
				Collections.factions.MAGIC: 0,
				Collections.factions.NATURE: 0,
				Collections.factions.ROBOT: 0,
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
		"Factions": [Collections.factions.NATURE, Collections.factions.ROBOT],
		"Costs": {
			Collections.factions.ANIMAL: 0,
			Collections.factions.MAGIC: 0,
			Collections.factions.NATURE: 2,
			Collections.factions.ROBOT: 2,
		},
		"Attack": 2,
		"Health": 2,
		"Movement": 1,
		"Lord": false,
		"Text": "When one of your units dies, grow 2",
		"CardFuncs": [{
			"ActiveFunc": false,
			"Costs": {
				Collections.factions.ANIMAL: 0,
				Collections.factions.MAGIC: 0,
				Collections.factions.NATURE: 0,
				Collections.factions.ROBOT: 0,
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

		## Animal ###

		cards.GORILLA:
			card = Gorilla
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
		cards.RHINOCEROS:
			card = Rhinoceros
		cards.FOLLOW_PHEROMONES:
			card = FollowPheromones
		cards.FELOS_EXPEDITIONIST:
			card = FelosExpeditionist
		cards.SKON_INSECT_FATHER:
			card = SkonInsectFather
		cards.STAMPEDE:
			card = Stampede
#
		#### Magic ###
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
		#cards.HYRSMIR_RULER_OF_PHYSICS:
			#card = HyrsmirRulerOfPhysics
		cards.FLOW_ACCELERATOR:
			card = FlowAccelerator
		cards.ARCANE_ARROW:
			card = ArcaneArrow
		#cards.PSYCHIC_TAKEOVER:
			#card = PsychicTakeover
#
		#### Nature ###
#
		#cards.GNOME_PROTECTOR:
			#card = GnomeProtector
		#cards.BOTANO_GARDENER:
			#card = BotanoGardener
		#cards.MORNING_LIGHT:
			#card = MorningLight
		#cards.ICE_GOLEM:
			#card = IceGolem
		#cards.FIRE_GOLEM:
			#card = FireGolem
		#cards.HAIL_STORM:
			#card = HailStorm
		#cards.EARTH_GOLEM:
			#card = EarthGolem
		#cards.PROTECTOR_OF_THE_FOREST:
			#card = ProtectorOfTheForest
		#cards.PRANCING_VERDEN:
			#card = PrancingVerden
		#cards.HEART_OF_THE_FOREST:
			#card = HeartOfTheForest
		#cards.MARCELLA_WHO_NURTURES_GROWTH:
			#card = MarcellaWhoNurturesGrowth
		#
		#### Robot ###
#
		#cards.ASSEMBLY_BOT:
			#card = AssemblyBot
		#cards.OBSTRUCTION_CONSTRUCTION:
			#card = ObstructionConstruction
		#cards.FACTORY_WORKER:
			#card = FactoryWorker
		#cards.NETWORK_FEEDER:
			#card = NetworkFeeder
		#cards.FURNACE_BOT:
			#card = FurnaceBot
		#cards.EXTERMINATE:
			#card = Exterminate
		#cards.SHOCK_CHARGE:
			#card = ShockCharge
		#cards.PLUG_BUDDY:
			#card = PlugBuddy
		#cards.COMPUTING_BOT:
			#card = ComputingBot
		#cards.ZOLOI_CHARGER:
			#card = ZoloiCharger
		#cards.COPY_MACHINE:
			#card = CopyMachine
		#cards.ZALOGI_MIND_OF_MACHINES:
			#card = ZalogiMindOfMachines
	return card
