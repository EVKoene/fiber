extends Node

var cards = load("res://card/CardDatabase.gd").cards


var animal_starter: Dictionary = {
	"DeckName": "AnimalStarter",
	"Cards": {
		cards.GORILLA: 4, 
		cards.ATTACK_COMMAND: 2, 
		cards.GOOSE: 2, 
		cards.WARTHOG_BERSERKER: 4, 
		cards.GORILLA_BATTLECALLER: 2, 
		cards.SNEK: 2,
		cards.FOLLOW_PHEROMONES: 3, 
		cards.STAMPEDE: 2, 
		cards.FELOS_EXPEDITIONIST: 3, 
		cards.SKON_INSECT_FATHER: 1	
	},
	"StartingCards": {
		cards.GORILLA: 2,
		cards.GOOSE: 1,
	},
	"ID": 1,
}


var magic_starter: Dictionary = {
	"DeckName": "MagicStarter",
	"Cards": {
		cards.WIZARD_SCOUT: 2,
		cards.SWITCHEROO: 2, 
		cards.ARCANE_ARROW: 4, 
		cards.MIST_CONJURER: 3, 
		cards.FLOW_ACCELERATOR: 4, 
		cards.EPHEMERAL_ASSASSIN: 2, 
		cards.FIREBALL_SHOOTER: 2, 
		cards.HOMUNCULUS: 4, 
		cards.JELLYFISH_EXTRAORDINAIRE: 2, 
		cards.AUDACIOUS_RESEARCHER: 2, 
		cards.HYRSMIR_RULER_OF_PHYSICS: 1, 
		cards.PSYCHIC_TAKEOVER: 2,
	},
	"StartingCards": {
		cards.WIZARD_SCOUT: 2,
		cards.ARCANE_ARROW: 1,
	},
	"ID": 2,
}

var nature_starter: Dictionary = {
	"DeckName": "NatureStarter",
	"Cards": {
		cards.GNOME_PROTECTOR: 2,  
		cards.BOTANO_GARDENER: 2, 
		cards.MORNING_LIGHT: 3, 
		cards.ICE_GOLEM: 2, 
		cards.FIRE_GOLEM: 2, 
		cards.HAIL_STORM: 2, 
		cards.EARTH_GOLEM: 4, 
		cards.PROTECTOR_OF_THE_FOREST: 2, 
		cards.PRANCING_VERDEN: 2, 
		cards.HEART_OF_THE_FOREST: 2, 
		cards.MARCELLA_WHO_NURTURES_GROWTH: 2, 
		cards.VOLCANIC_ERUPTION: 2
	},
	"StartingCards": {
		cards.GNOME_PROTECTOR: 2,
		cards.BOTANO_GARDENER: 1,
	},
	"ID": 3,
}

var robot_starter: Dictionary = {
	"DeckName": "RobotStarter",
	"Cards": {
		cards.ASSEMBLY_BOT: 1, 
		cards.OBSTRUCTION_CONSTRUCTION: 2, 
		cards.SHOCK_CHARGE: 3, 
		cards.FACTORY_WORKER: 2, 
		cards.NETWORK_FEEDER: 3, 
		cards.FURNACE_BOT: 2, 
		cards.EXTERMINATE: 2, 
		cards.PLUG_BUDDY: 3, 
		cards.COMPUTING_BOT: 1, 
		cards.ZOLOI_CHARGER: 2, 
		cards.COPY_MACHINE: 1, 
		cards.ZALOGI_MIND_OF_MACHINES: 2, 
	},
	"StartingCards":  {
		cards.ASSEMBLY_BOT: 2,
		cards.FACTORY_WORKER: 1,
	},
	"ID": 4,
}

var gorilla: Dictionary = {
	"DeckName": "Gorilla",
	"Cards": {
		cards.GORILLA: 20,
		cards.GORILLA_BATTLECALLER: 10,
		cards.GORILLA_KING: 20,
	},
	"StartingCards": {
		cards.GORILLA: 3,
	},
	"ID": 5,
}

var magic_missiles: Dictionary = {
	"DeckName": "MagicMissiles",
	"Cards": {
		cards.WIZARD_SCOUT: 15,
		cards.ARCANE_ARROW: 10,
		cards.FIREBALL_SHOOTER: 15,
		cards.JELLYFISH_EXTRAORDINAIRE: 5,
	},
	"StartingCards": {
		cards.WIZARD_SCOUT: 2,
		cards.ARCANE_ARROW: 1,
	},
	"ID": 6,
}

var robot_factory: Dictionary = {
	"DeckName": "Robot Factory",
	"Cards": {
		cards.ASSEMBLY_BOT: 15, 
		cards.NETWORK_FEEDER: 15, 
		cards.FURNACE_BOT: 5,
		cards.COMPUTING_BOT: 5 
	},
	"StartingCards": {
		cards.ASSEMBLY_BOT: 3,
	},
	"ID": 7,
}

var beefy_boys: Dictionary = {
	"DeckName": "Beefy Boys",
	"Cards": {
		cards.GNOME_PROTECTOR: 10,  
		cards.MORNING_LIGHT: 15, 
		cards.EARTH_GOLEM: 15, 
		cards.HEART_OF_THE_FOREST: 5, 
	},
	"StartingCards": {
		cards.GNOME_PROTECTOR: 2,
		cards.MORNING_LIGHT: 1,
	},
	"ID": 8,
}


var opponent_testing: Dictionary = {
	"Cards": {
		cards.GORILLA: 4, 
		cards.GOOSE: 4, 
		cards.WARTHOG_BERSERKER: 4, 
		cards.GORILLA_BATTLECALLER: 2, 
		cards.SNEK: 2, 
		cards.FELOS_EXPEDITIONIST: 3,
	},
	"StartingCards": {
		cards.GORILLA: 2,
	}
}

var player_testing: Dictionary = {
	"Cards": {
		cards.GORILLA: 10,
	},
	"StartingCards": {
		cards.GORILLA_KING: 3
	},
	"ID": 0,
	"DeckName": "Player testing",
}


func random_deck() -> int:
	var rand_deck: int = decks.keys().pick_random()
	return rand_deck

var decks := {
	1: animal_starter, 
	2: magic_starter, 
	3: nature_starter, 
	4: robot_starter,
	5: gorilla, 
	6: magic_missiles, 
	7: beefy_boys, 
	8: robot_factory, 
}
