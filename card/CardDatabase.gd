extends Node

# All the exisiting cards go into this enum
enum cards {
	### PASSION ### (16)
	GORILLA, FANATIC_FOLLOWER, ATTACK_COMMAND, GOOSE, CRAZED_GAMBLER, VIGOR, WARTHOG_BERSERKER, 
	GORILLA_BATTLECALLER, SNEK, FOLLOW_PHEROMONES, YOUNG_DRIVEN_MINOTAUR, STAMPEDE, 
	FELOS_EXPEDITIONIST, CHEETAH, GORILLA_KING, SKON_INSECT_FATHER, 
	
	### IMAGINATION ### (17)
	WIZARD_SCOUT, IMAGINARY_FRIEND, SWITCHEROO, ARCANE_ARROW, INSPIRING_ARTIST, MIST_CONJURER, 
	DREAMFINDER, FLOW_ACCELERATOR, EPHEMERAL_ASSASSIN, FIREBALL_SHOOTER, HOMUNCULUS, 
	JELLYFISH_EXTRAORDINAIRE, AUDACIOUS_RESEARCHER, OVERSTIMULATION_FIEND, STREAM_OF_THOUGHT, 
	HYRSMIR_RULER_OF_PHYSICS, PSYCHIC_TAKEOVER,  
	
	### GROWTH ### (16)
	GNOME_PROTECTOR, PATIENT_MOTHERFUCKER, BOTANO_GARDENER, MORNING_LIGHT, WIND_GOLEM, ICE_GOLEM, 
	FIRE_GOLEM, STUDENT_OF_KHONG, HAIL_STORM, EARTH_GOLEM, BRINGER_OF_ENLIGHTENMENT, PROTECTOR_OF_THE_FOREST, 
	PRANCING_VERDEN, HEART_OF_THE_FOREST, MARCELLA_WHO_NURTURES_GROWTH, VOLCANIC_ERUPTION, 
	
	### LOGIC ### (15)
	FACTORY_WORKER, OBSTRUCTION_CONSTRUCTION, SHOCK_CHARGE, ASSEMBLY_BOT, FUEL_DISTRIBUTER, 
	NETWORK_FEEDER, RESOURCE_EXTRACTOR, FURNACE_BOT, EXTERMINATE, PLUG_BUDDY, COMPUTING_BOT, 
	ZOLOI_CHARGER, COPY_MACHINE, ZALOGI_MIND_OF_MACHINES, SUPPLY_DELIVERY, 
	
	### MULTIFIBER ###
	PLUTO_MUSICAL_GUIDE, MIDAVES_RESEARCHER_OF_LIFE, 
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
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 1,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 0,
		"Health": 2,
		"Movement": 1,
		"Lord": false,
		"Purposes": [],
		"Text": "",
		"IMGPath": "res://assets/card_images/passion/Gorilla.png",
	},
	
	cards.FANATIC_FOLLOWER: {
		"InGameName": "Fanatic Follower",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 1,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 1,
		"MinAttack": 0,
		"Health": 1,
		"Movement": 2,
		"Lord": false,
		"Purposes": [Collections.purposes.CONQUER_SPACES],
		"Text": "",
		"IMGPath": "res://assets/card_images/passion/FanaticFollower.png",
	},
	
	cards.ATTACK_COMMAND: {
		"InGameName": "Attack Command",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 1,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"TargetRestrictions": TargetSelection.target_restrictions.OWN_UNITS,
		"Text": "Pick one of your units. Deal damage equal to it's max attack to a unit in range 2.",
		"CardRange": 2,
		"IMGPath": "res://assets/card_images/passion/AttackCommand.png",
	},
	
	cards.GOOSE: {
		"InGameName": "Goose",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 2,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.BATTLE, Collections.purposes.DEFEND_RESOURCE],
		"IMGPath": "res://assets/card_images/passion/Goose.png",
	},
	
	cards.CRAZED_GAMBLER: {
		"InGameName": "Crazed Gambler",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 2,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 5,
		"MinAttack": 1,
		"Health": 1,
		"Movement": 1,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://assets/card_images/passion/CrazedGambler.jpg",
	},
	
	cards.VIGOR: {
		"InGameName": "Vigor",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 2,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"CardRange": -1,
		"Text": "Your units get 1 movement and 1 max attack until your next turn.",
		"IMGPath": "res://assets/card_images/passion/Vigor.png",
	},
	
	cards.WARTHOG_BERSERKER: {
		"InGameName": "Warthog Berserker",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 3,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 3,
		"Movement": 2,
		"Lord": false,
		"Text": "Frenzy (move towards the closest enemy unit and attack if possible. Then exhaust)",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://assets/card_images/passion/WarthogBerserker.png",
	},
	
	cards.SNEK: {
		"InGameName": "Snek",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 3,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "When an opponent unit enters an adjacent space, deal 1 damage to it",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
	
		"IMGPath": "res://assets/card_images/passion/Snek.jpg",
		},
		
	cards.FOLLOW_PHEROMONES: {
		"InGameName": "Follow Pheromones",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 3,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "Look at the top cards of your deck until you find 2 units. Draw them and put the 
		rest on the bottom of your deck.",
		"IMGPath": "res://assets/card_images/passion/FollowPheromones.png",
	},
	
	cards.YOUNG_DRIVEN_MINOTAUR: {
		"InGameName": "Young Driven Minotaur",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 4,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 2,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "When one of your other units in range 2 attacks, add 1 max attack and 1 health to 
		this unit.",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://assets/card_images/passion/YoungDrivenMinotaur.jpg",
	},
	
	cards.GORILLA_BATTLECALLER: {
		"InGameName": "Gorilla Battlecaller",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 4,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "Add 2 max attack and 1 movement to the units in adjacent spaces",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://assets/card_images/passion/GorillaBattlecaller.png",
	},
	
	cards.STAMPEDE: {
		"InGameName": "Stampede",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 5,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "All your units get +2/+2/+2 and +1 movement until your next turn",
		"IMGPath": "res://assets/card_images/passion/Stampede.png",
	},
	
	cards.FELOS_EXPEDITIONIST: {
		"InGameName": "Felos Expeditionist",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 5,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 5,
		"MinAttack": 3,
		"Health": 6,
		"Movement": 1,
		"Lord": false,
		"Text": "On Attack: Draw a Card",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://assets/card_images/passion/FelosExpeditionist.png",
	},
	
	cards.CHEETAH: {
		"InGameName": "Cheetah",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 5,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 6,
		"MinAttack": 3,
		"Health": 4,
		"Movement": 4,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://assets/card_images/passion/Cheetah.png",
	},
	
	cards.GORILLA_KING: {
		"InGameName": "GorillaKing",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 6,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 5,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": true,
		"Text": "Your units get +2 max attack for each adjacent unit",
		"Purposes": [],
		"IMGPath": "res://assets/card_images/passion/GorillaKing.png",
	},
	
	cards.SKON_INSECT_FATHER: {
		"InGameName": "S`kon, Insect Father",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION],
		"Costs": {
			Collections.fibers.PASSION: 6,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 5,
		"Movement": 1,
		"Lord": true,
		"Text": "Exhaust: Create a 1-1/1 <N> Insect fabrication with frenzy, 2 movement, and 'this 
		unit deals 1 damage to itself when attacking' in each adjacent space",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
		"IMGPath": "res://assets/card_images/passion/SkonInsectFather.png",
	},
	
	### IMAGINATION ###
	
	cards.WIZARD_SCOUT: {
		"InGameName": "Wizard Scout",
		"fibers": [Collections.fibers.IMAGINATION],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 1,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 1,
		"MinAttack": 1,
		"Health": 2,
		"Movement": 1,
		"Lord": false,
		"Text": "Exhaust: Swap with one of your own units",
		"Purposes": [],
		"IMGPath": "res://assets/card_images/imagination/WizardApprentice.png",
	},
	
	cards.IMAGINARY_FRIEND: {
		"InGameName": "Imaginary Friend",
		"fibers": [Collections.fibers.IMAGINATION],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 1,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 1,
		"MinAttack": 1,
		"Health": 2,
		"Movement": 1,
		"Lord": false,
		"Text": "Whenever you play a spell, increase a random battlestat by 1.",
		"Purposes": [],
		"IMGPath": "res://assets/card_images/imagination/ImaginaryFriend.png",
	},
	
	cards.SWITCHEROO: {
		"InGameName": "Switcheroo",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 1,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_UNITS,
		"Text": "Pick two units with the same owner and swap them.",
		"IMGPath": "res://assets/card_images/imagination/Switcheroo.png",
	},
	
	cards.MIST_CONJURER: {
		"InGameName": "Mist Conjurer",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 2,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 1,
		"Movement": 1,
		"Lord": false,
		"Text": "Opponent units in adjacent spaces get -1 Max attack",
		"Purposes": [Collections.purposes.BATTLE, Collections.purposes.DEBUFF_ADJACENT],
		"IMGPath": "res://assets/card_images/imagination/MistConjurer.png",
	},
	
	cards.INSPIRING_ARTIST: {
		"InGameName": "Inspiring Artist",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 2,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "Add 1 movement to the units in adjacent spaces",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://assets/card_images/imagination/InspiringArtist.png",
	},
	
	cards.ARCANE_ARROW: {
		"InGameName": "Arcane Arrow",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 2,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"CardRange": 2,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_UNITS,
		"Text": "Deal 3 damage to a unit",
		"IMGPath": "res://assets/card_images/imagination/ArcaneArrow.png",
	},
	
	cards.FIREBALL_SHOOTER: {
		"InGameName": "Fireball Shooter",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 3,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Purposes": [Collections.purposes.REAR],
		"Lord": false,
		"Text": "Exhaust: deal 1 damage to all enemey units in any direction from this unit",
		"IMGPath": "res://assets/card_images/imagination/FireballShooter.png",
	},

cards.FLOW_ACCELERATOR: {
		"InGameName": "Flow Accelerator",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 3,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "When this unit moves, it gets +1 max attack and health for each space it moved until your next turn",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://assets/card_images/imagination/FlowAccelerator.png",
	},
	
	cards.DREAMFINDER: {
		"InGameName": "Dreamfinder",
		"fibers": [Collections.fibers.IMAGINATION],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 3,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 1,
		"MinAttack": 4,
		"Health": 4,
		"Movement": 1,
		"Lord": false,
		"Text": "Your spells cost 1 less {I}",
		"Purposes": [],
		"IMGPath": "res://assets/card_images/imagination/Dreamfinder.png",
	},
	
	cards.AUDACIOUS_RESEARCHER: {
		"InGameName": "Audacious Researcher",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.IMAGINATION],
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 4,
		"Movement": 1,
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 4,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"Lord": false,
		"Purposes": [Collections.purposes.BATTLE],
		"Text": "At the start of your turn, if this unit is in a row that's at least halfway towards
		your opponent: draw the top spell in your deck.",
		"IMGPath": "res://assets/card_images/imagination/AudaciousResearcher.png",
	},
	
	cards.HOMUNCULUS: {
		"InGameName": "Homunculus",
		"fibers": [Collections.fibers.IMAGINATION],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 4,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 5,
		"MinAttack": 3,
		"Health": 5,
		"Movement": 1,
		"Lord": false,
		"Purposes": [Collections.purposes.BATTLE],
		"Text": "",
		"IMGPath": "res://assets/card_images/imagination/Homunculus.png",
	},
	
	cards.OVERSTIMULATION_FIEND: {
		"InGameName": "Overstimulation Fiend",
		"fibers": [Collections.fibers.IMAGINATION],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 4,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Purposes": [Collections.purposes.DEBUFF_ADJACENT],
		"Text": "Opponent units in adjacent spaces get -1 movement",
		"IMGPath": "res://assets/card_images/imagination/OverstimulationFiend.png",
	},
	
	cards.STREAM_OF_THOUGHT: {
		"InGameName": "Stream of Thought",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 4,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"CardRange": 2,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_UNITS,
		"Text": "Deal 4 damage to a unit. Draw a card.",
		"IMGPath": "res://assets/card_images/imagination/StreamOfThought.png",
	},
	
	cards.EPHEMERAL_ASSASSIN: {
		"InGameName": "Ephemeral Assassin",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 5,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 6,
		"MinAttack": 2,
		"Health": 3,
		"Movement": 3,
		"Lord": false,
		"Text": "This unit can move through units",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://assets/card_images/imagination/EphemeralAssassin.png",
	},
	
	cards.JELLYFISH_EXTRAORDINAIRE: {
		"InGameName": "Jellyfish Extraordinaire",
		"fibers": [Collections.fibers.IMAGINATION],
		"CardType": Collections.card_types.UNIT,
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 5,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
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
		"IMGPath": "res://assets/card_images/imagination/JellyfishExtraordinaire.jpg",
	},
	
	cards.HYRSMIR_RULER_OF_PHYSICS: {
		"InGameName": "Hyrsmir, Ruler of Physics",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 6,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 5,
		"Movement": 1,
		"Lord": true,
		"Text": "At the start of your turn: Swap any number of units any number of times.",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://assets/card_images/imagination/HyrsmirRulerOfPhysics.png",
	},
	
	cards.PSYCHIC_TAKEOVER: {
		"InGameName": "Psychic Takeover",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 6,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"TargetRestrictions": TargetSelection.target_restrictions.OPPONENT_UNITS,
		"CardRange": 1,
		"Text": "Gain control of an enemy unit",
		"IMGPath": "res://assets/card_images/imagination/PsychicTakeover.png",
	},
	
	### GROWTH ###
	
	cards.GNOME_PROTECTOR: {
		"InGameName": "Gnome Protector",
		"fibers": [Collections.fibers.GROWTH],
		"CardType": Collections.card_types.UNIT,
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 2,
		"Movement": 1,
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 1,
			Collections.fibers.LOGIC: 0,
		},
		"Lord": false,
		"Text": "Your units in adjacent spaces have +1 health",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://assets/card_images/growth/GnomeProtector.png",
	},
	
	cards.PATIENT_MOTHERFUCKER: {
		"InGameName": "Patient Motherfucker",
		"fibers": [Collections.fibers.GROWTH],
		"CardType": Collections.card_types.UNIT,
		"MaxAttack": 1,
		"MinAttack": 1,
		"Health": 2,
		"Movement": 1,
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 1,
			Collections.fibers.LOGIC: 0,
		},
		"Lord": false,
		"Text": "If this unit didn't move in your last turn, it gets +2 max attack, +2 min attack 
		and +2 shield until your next turn",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
		"IMGPath": "res://assets/card_images/growth/PatientMotherfucker.png",
	},
	
	cards.MORNING_LIGHT: {
		"InGameName": "Morning Light",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 1,
			Collections.fibers.LOGIC: 0,
		},
		"CardRange": 0,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_UNITS,
		"Text": "Target unit gets 2 health and +1 movement.",
		"IMGPath": "res://assets/card_images/growth/MorningLight.jpg",
	},
	
	cards.BOTANO_GARDENER: {
		"CardType": Collections.card_types.UNIT,
		"InGameName": "Botano Gardener",
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 2,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 2,
		"Movement": 1,
		"Purposes": [Collections.purposes.REAR],
		"Lord": false,
		"Text": "Exhaust: Add 1 min attack and 1 health to an adjacent unit",
		"IMGPath": "res://assets/card_images/growth/BotanoGardener.png",
	},
	
	cards.FIRE_GOLEM: {
		"InGameName": "Fire Golem",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 2,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "Exhaust: This unit deals damage equal to it's min attack to each enemy unit in a range 
		of 2",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://assets/card_images/growth/FireGolem.jpg",
	},
	
	cards.WIND_GOLEM: {
		"InGameName": "Wind Golem",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 2,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 2,
		"Health": 2,
		"Movement": 2,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.CONQUER_SPACES],
		"IMGPath": "res://assets/card_images/growth/WindGolem.png",
	},
	
	cards.STUDENT_OF_KHONG: {
		"InGameName": "Student of Khong",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 3,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 1,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "When this unit attacks, add it's health to it's min attack for 1 turn",
		"Purposes": [Collections.purposes.BATTLE,],
		"IMGPath": "res://assets/card_images/growth/StudentOfKhong.png",
	},
	
	cards.HAIL_STORM: {
		"InGameName": "Hail Storm",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 3,
			Collections.fibers.LOGIC: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "Select a 3 x 3 square at range 1. All units in that square get -1/-0 and -1 movement.",
		"IMGPath": "res://assets/card_images/growth/HailStorm.jpg",
	},
	
	cards.ICE_GOLEM: {
		"InGameName": "Ice Golem",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 3,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 5,
		"Movement": 1,
		"Lord": false,
		"Text": "When Ice Golem deals damage to a unit, that unit gets -1/-0 and -1 movement until
		your next turn",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://assets/card_images/growth/IceGolem.jpg",
	},
	
	cards.EARTH_GOLEM: {
		"InGameName": "Earth Golem",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 4,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 2,
		"MinAttack": 2,
		"Health": 7,
		"Movement": 1,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://assets/card_images/growth/EarthGolem.png",
	},
	
	cards.PROTECTOR_OF_THE_FOREST: {
		"InGameName": "Protector of the Forest",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 4,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 4,
		"Movement": 1,
		"Lord": false,
		"Text": "At the start of your turn: If Protector didn't move since your last turn, it gets +2 health",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE, Collections.purposes.BATTLE,],
		"IMGPath": "res://assets/card_images/growth/ProtectorOfTheForest.jpg",
	},

	cards.HEART_OF_THE_FOREST: {
		"InGameName": "Heart of the Forest",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 5,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 0,
		"MinAttack": 0,
		"Health": 8,
		"Movement": 0,
		"Lord": false,
		"Text": "Allied units in range 1 get +0/+4. Units in range 2 get +0/+2",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://assets/card_images/growth/HeartOfTheForest.jpg",
	},
	
	cards.BRINGER_OF_ENLIGHTENMENT: {
		"InGameName": "Bringer of Enlightenment",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 5,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 5,
		"Movement": 1,
		"Lord": false,
		"Text": "At the start of your turn, your other units in range 2 with at least 5 health get 
		+3 max attack until the end of turn",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://assets/card_images/growth/BringerOfEnlightenment.png",
	},
	
	cards.VOLCANIC_ERUPTION: {
		"InGameName": "Volcanic Eruption",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 5,
			Collections.fibers.LOGIC: 0,
		},
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"Text": "Select a 4 x 4 square at range 1. Deal 2 damage to each enemy unit in the selected 
		square.",
		"IMGPath": "res://assets/card_images/growth/VolcanicEruption.jpg",
	},
	
	cards.PRANCING_VERDEN: {
		"InGameName": "Prancing Verden",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 6,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 3,
		"MinAttack": 2,
		"Health": 3,
		"Movement": 4,
		"Lord": false,
		"Text": "This unit can move through units. If it moves through a friendly unit, that unit
		gets +2 movement and +1 min attack this turn.",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://assets/card_images/growth/PrancingVerden.jpg",
	},
	
	cards.MARCELLA_WHO_NURTURES_GROWTH: {
		"InGameName": "Marcella, Who Nurtures Growth",
		"CardType": Collections.card_types.UNIT,		
		"fibers": [Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 6,
			Collections.fibers.LOGIC: 0,
		},
		"MaxAttack": 4,
		"MinAttack": 3,
		"Health": 7,
		"Movement": 1,
		"Lord": true,
		"Text": "Pay 2<N>: Draw a card, add 1 min attack and 1 health to up to one adjacent unit",
		"Purposes": [Collections.purposes.REAR,],
		"IMGPath": "res://assets/card_images/growth/MarcellaWhoNurturesGrowth.png",
	},
	
	### LOGIC ###
	
	cards.ASSEMBLY_BOT: {
		"InGameName": "Assembly Bot",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 1,
		},
		"MaxAttack": 1,
		"MinAttack": 0,
		"Health": 1,
		"Movement": 1,
		"Lord": false,
		"Text": "When this unit enters battle, create a 1-1/1 logic fabrication in an adjacent space
		with 1 movement",
		"Purposes": [],
		"IMGPath": "res://assets/card_images/logic/AssemblyBot.png",
	},
	
	cards.OBSTRUCTION_CONSTRUCTION: {
		"InGameName": "Obstruction Construction",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 1,
		},
		"MaxAttack": 0,
		"MinAttack": 0,
		"Health": 4,
		"Movement": 1,
		"Lord": false,
		"Text": "",
		"Purposes": [Collections.purposes.DEFEND_RESOURCE],
		"IMGPath": "res://assets/card_images/logic/ObstructionConstruction.png",
	},
	
	cards.SHOCK_CHARGE: {
		"InGameName": "Shock Charge",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 1,
		},
		"Text": "Refresh up to two units.",
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"IMGPath": "res://assets/card_images/logic/ShockCharge.jpg",
	},
	
	cards.FACTORY_WORKER: {
		"InGameName": "Factory Worker",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 2,
		},
		"MaxAttack": 2,
		"MinAttack": 0,
		"Health": 3,
		"Movement": 1,
		"Purposes": [Collections.purposes.REAR],
		"Lord": false,
		"Text": "Exhaust: Add 1 {R}",
		"IMGPath": "res://assets/card_images/logic/FactoryWorker.png",
	},
	
	cards.FUEL_DISTRIBUTER: {
		"InGameName": "Fuel Distributer",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 2,
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 2,
		"Movement": 1,
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"Lord": false,
		"Text": "<R>, Exhaust: Add 1 movement, 1 min attack, 1 max attack and 1 health to each 
		adjacent unit until your next turn",
		"IMGPath": "res://assets/card_images/logic/FuelDistributer.png",
	},
	
	cards.NETWORK_FEEDER: {
		"InGameName": "Network Feeder",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 3,
		},
		"MaxAttack": 1,
		"MinAttack": 1,
		"Health": 2,
		"Movement": 1,
		"Lord": false,
		"Text": "This unit gets 2 max attack and 2 health for each adjacent allied unit",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://assets/card_images/logic/NetworkFeeder.jpg",
	},
	
	cards.RESOURCE_EXTRACTOR: {
		"InGameName": "Resource extractor",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 3,
		},
		"MaxAttack": 4,
		"MinAttack": 1,
		"Health": 4,
		"Movement": 1,
		"Lord": false,
		"Text": "When this unit attacks, add 2 <R>",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://assets/card_images/logic/ResourceExtractor.png",
	},
	
	cards.EXTERMINATE: {
		"InGameName": "Exterminate",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 3,
		},
		"Text": "Consume one of your own units: Destroy a unit within range 1 of the consumed unit",
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.OWN_UNITS,
		"IMGPath": "res://assets/card_images/logic/Exterminate.jpg",
	
	},
	
	cards.FURNACE_BOT: {
		"InGameName": "Furnace Bot",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 4,
		},
		"MaxAttack": 2,
		"MinAttack": 1,
		"Health": 4,
		"Movement": 2,
		"Lord": false,
		"Text": "Consume a unit in range 1: This unit gets +1 max attack, min attack and health",
		"Purposes": [Collections.purposes.BATTLE],
		"IMGPath": "res://assets/card_images/logic/FurnaceBot.jpg",
	},
	
	cards.ZOLOI_CHARGER: {
		"InGameName": "Zoloi Charger",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 4,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 5,
		"Movement": 1,
		"Lord": false,
		"Text": "If there's a unit to the left and right of this unit at the start of your turn, this unit gets +3 max attack, Impact and +2 movement until your next turn",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://assets/card_images/logic/ZoloiCharger.png",
	},
	
	cards.PLUG_BUDDY: {
		"InGameName": "Plug Buddy",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 5,
		},
		"MaxAttack": 3,
		"MinAttack": 1,
		"Health": 3,
		"Movement": 1,
		"Lord": false,
		"Text": "Exhaust, 2<R>: Refresh all your other units in range 1",
		"Purposes": [Collections.purposes.BUFF_ADJACENT],
		"IMGPath": "res://assets/card_images/logic/PlugBuddy.jpg",
	},
	
	cards.COMPUTING_BOT: {
		"InGameName": "Computing Bot",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 5,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 6,
		"Lord": false,
		"Movement": 1,
		"Text": "Exhaust, 1<R>: Consume a unit in range 1: Discard 1 card and draw 3 cards",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://assets/card_images/logic/ComputingBot.jpg",
	},
	
	cards.COPY_MACHINE: {
		"InGameName": "Copy Machine",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 6,
		},
		"MaxAttack": 4,
		"MinAttack": 2,
		"Health": 5,
		"Movement": 1,
		"Lord": false,
		"Text": "Exhaust, 3<R>: Choose a unit in range 1. Create a fabrication that's a copy of that
		unit in range 1. Exhaust it.",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://assets/card_images/logic/CopyMachine.png",
	},
	
	cards.ZALOGI_MIND_OF_MACHINES: {
		"InGameName": "Zalogi, Mind Of Machines",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 6,
		},
		"MaxAttack": 6,
		"MinAttack": 4,
		"Health": 7,
		"Movement": 1,
		"Lord": true,
		"Text": "Your fabrications are created with +2 max attack, min attack and health and +1 movement",
		"Purposes": [Collections.purposes.REAR],
		"IMGPath": "res://assets/card_images/logic/ZalogiMindOfMachines.png",
	},
	
	cards.SUPPLY_DELIVERY: {
		"InGameName": "Supply Delivery",
		"CardType": Collections.card_types.SPELL,
		"fibers": [Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 6,
		},
		"Text": "Pick up to 3 spaces in your territory. Create a 3-3/3 Battle Bot fabrication in
		each chosen space.",
		"CardRange": -1,
		"TargetRestrictions": TargetSelection.target_restrictions.ANY_SPACE,
		"IMGPath": "res://assets/card_images/logic/SupplyDelivery.png",
	
	},
	
	cards.PLUTO_MUSICAL_GUIDE: {
		"InGameName": "Pluto, Musical Guide",
		"CardType": Collections.card_types.UNIT,
		"fibers": [Collections.fibers.PASSION, Collections.fibers.IMAGINATION],
		"Costs": {
			Collections.fibers.PASSION: 2,
			Collections.fibers.IMAGINATION: 3,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 0,
		},
		"Attack": 4,
		"Health": 4,
		"Movement": 2,
		"Lord": true,
		"Text": "Exhaust: Choose a creature that attacks twice this turn",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.fibers.PASSION: 0,
				Collections.fibers.IMAGINATION: 0,
				Collections.fibers.GROWTH: 0,
				Collections.fibers.LOGIC: 0,
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
		"fibers": [Collections.fibers.PASSION, Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 1,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 3,
			Collections.fibers.LOGIC: 0,
		},
		"Attack": 3,
		"Health": 5,
		"Movement": 1,
		"Lord": true,
		"Text": "Exhaust: Grow 1. If the unit you´ve grown attacks this turn, cycle 1",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.fibers.PASSION: 0,
				Collections.fibers.IMAGINATION: 0,
				Collections.fibers.GROWTH: 0,
				Collections.fibers.LOGIC: 0,
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
		"fibers": [Collections.fibers.PASSION, Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 3,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 1,
		},
		"Attack": 5,
		"Health": 3,
		"Movement": 2,
		"Lord": false,
		"Text": "Fight",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.fibers.PASSION: 0,
				Collections.fibers.IMAGINATION: 0,
				Collections.fibers.GROWTH: 0,
				Collections.fibers.LOGIC: 0,
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
		"fibers": [Collections.fibers.IMAGINATION, Collections.fibers.GROWTH],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 2,
			Collections.fibers.GROWTH: 2,
			Collections.fibers.LOGIC: 0,
		},
		"Attack": 2,
		"Health": 3,
		"Movement": 1,
		"Lord": true,
		"Text": "Exhaust: Grow 2, then deal 2 damage",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.fibers.PASSION: 0,
				Collections.fibers.IMAGINATION: 1,
				Collections.fibers.GROWTH: 1,
				Collections.fibers.LOGIC: 0,
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
		"fibers": [Collections.fibers.IMAGINATION, Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 2,
			Collections.fibers.GROWTH: 0,
			Collections.fibers.LOGIC: 2,
		},
		"Attack": 3,
		"Health": 3,
		"Movement": 3,
		"Lord": true,
		"Text": "Battle\n Exhaust: Deal 3 damage",
		"CardFuncs": [{
			"ActiveFunc": true,
			"Costs": {
				Collections.fibers.PASSION: 0,
				Collections.fibers.IMAGINATION: 1,
				Collections.fibers.GROWTH: 1,
				Collections.fibers.LOGIC: 0,
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
		"fibers": [Collections.fibers.GROWTH, Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 1,
			Collections.fibers.LOGIC: 1,
		},
		"Attack": 2,
		"Health": 2,
		"Movement": 1,
		"Lord": true,
		"Text": "You may use resources of any faction to pay for cards and abilities",
		"CardFuncs": [{
			"ActiveFunc": false,
			"Costs": {
				Collections.fibers.PASSION: 0,
				Collections.fibers.IMAGINATION: 0,
				Collections.fibers.GROWTH: 0,
				Collections.fibers.LOGIC: 0,
			},
			"FuncName": "ignore_fibers_for_resources",
			"FuncText": "Ignore fibers for resources",
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
		"fibers": [Collections.fibers.GROWTH, Collections.fibers.LOGIC],
		"Costs": {
			Collections.fibers.PASSION: 0,
			Collections.fibers.IMAGINATION: 0,
			Collections.fibers.GROWTH: 2,
			Collections.fibers.LOGIC: 2,
		},
		"Attack": 2,
		"Health": 2,
		"Movement": 1,
		"Lord": false,
		"Text": "When one of your units dies, grow 2",
		"CardFuncs": [{
			"ActiveFunc": false,
			"Costs": {
				Collections.fibers.PASSION: 0,
				Collections.fibers.IMAGINATION: 0,
				Collections.fibers.GROWTH: 0,
				Collections.fibers.LOGIC: 0,
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
		cards.GOOSE:
			card = Goose
		cards.VIGOR:
			card = Vigor
		cards.CRAZED_GAMBLER:
			card = CrazedGambler
		cards.WARTHOG_BERSERKER:
			card = WarthogBerserker
		cards.SNEK:
			card = Snek
		cards.GORILLA_BATTLECALLER:
			card = GorillaBattlecaller
		cards.FOLLOW_PHEROMONES:
			card = FollowPheromones
		cards.YOUNG_DRIVEN_MINOTAUR:
			card = YoungDrivenMinotaur
		cards.GORILLA_KING:
			card = GorillaKing
		cards.FELOS_EXPEDITIONIST:
			card = FelosExpeditionist
		cards.CHEETAH:
			card = Cheetah
		cards.STAMPEDE:
			card = Stampede
		cards.SKON_INSECT_FATHER:
			card = SkonInsectFather
#
		#### Imagination ###
#
		cards.WIZARD_SCOUT:
			card = WizardScout
		cards.IMAGINARY_FRIEND:
			card = ImaginaryFriend
		cards.SWITCHEROO:
			card = Switcheroo
		cards.FLOW_ACCELERATOR:
			card = FlowAccelerator
		cards.INSPIRING_ARTIST:
			card = InspiringArtist
		cards.ARCANE_ARROW:
			card = ArcaneArrow
		cards.MIST_CONJURER:
			card = MistConjurer
		cards.FIREBALL_SHOOTER:
			card = FireballShooter
		cards.DREAMFINDER:
			card = Dreamfinder
		cards.AUDACIOUS_RESEARCHER:
			card = AudaciousResearcher
		cards.HOMUNCULUS:
			card = Homunculus
		cards.JELLYFISH_EXTRAORDINAIRE:
			card = JellyfishExtraordinaire
		cards.OVERSTIMULATION_FIEND:
			card = OverstimulationFiend
		cards.STREAM_OF_THOUGHT:
			card = StreamOfThought
		cards.HYRSMIR_RULER_OF_PHYSICS:
			card = HyrsmirRulerOfPhysics
		cards.EPHEMERAL_ASSASSIN:
			card = EphemeralAssassin
		cards.PSYCHIC_TAKEOVER:
			card = PsychicTakeover
#
		#### Growth ###
#
		cards.GNOME_PROTECTOR:
			card = GnomeProtector
		cards.PATIENT_MOTHERFUCKER:
			card = PatientMotherfucker
		cards.BOTANO_GARDENER:
			card = BotanoGardener
		cards.MORNING_LIGHT:
			card = MorningLight
		cards.ICE_GOLEM:
			card = IceGolem
		cards.WIND_GOLEM:
			card = WindGolem
		cards.FIRE_GOLEM:
			card = FireGolem
		cards.STUDENT_OF_KHONG:
			card = StudentOfKhong
		cards.HAIL_STORM:
			card = HailStorm
		cards.EARTH_GOLEM:
			card = EarthGolem
		cards.PROTECTOR_OF_THE_FOREST:
			card = ProtectorOfTheForest
		cards.BRINGER_OF_ENLIGHTENMENT:
			card = BringerOfEnlightenment
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
		cards.FUEL_DISTRIBUTER:
			card = FuelDistributer
		cards.NETWORK_FEEDER:
			card = NetworkFeeder
		cards.RESOURCE_EXTRACTOR:
			card = ResourceExtractor
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
		cards.SUPPLY_DELIVERY:
			card = SupplyDelivery
	
	return card
