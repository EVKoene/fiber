extends Node

var cards = load("res://card/CardDatabase.gd").cards

var animal_deck: Dictionary = {
	"Cards": {
		cards.GORILLA: 4, 
		cards.ATTACK_COMMAND: 2, 
		cards.GOOSE: 2, 
		cards.WARTHOG_BERSERKER: 4, 
		cards.GORILLA_BATTLECALLER: 2, 
		cards.SNEK: 2,
		cards.FOLLOW_PHEROMONES: 3, 
		cards.RHINOCEROS: 3, 
		cards.STAMPEDE: 2, 
		cards.FELOS_EXPEDITIONIST: 3, 
		cards.SKON_INSECT_FATHER: 1	
	},
	"StartingCards": {
		cards.GORILLA: 2,
	}
}


var magic_deck: Dictionary = {
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
	}
}

var nature_deck: Dictionary = {
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
		cards.GNOME_PROTECTOR: 1,
		cards.BOTANO_GARDENER: 1,
	}
}

var robot_deck: Dictionary = {
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
		cards.ASSEMBLY_BOT: 1,
		cards.FACTORY_WORKER: 1,
	},
}




var nature_robot_deck: Dictionary = {
	cards.FACTORY_WORKER: 10,
	cards.ASSEMBLY_BOT: 7,
	cards.ZOLOI_CHARGER: 5,
	cards.ZALOGI_MIND_OF_MACHINES: 2,
	cards.SPOTOS_RECYCLER: 8,
	cards.BOTANO_GARDENER: 10,
	cards.EARTH_GOLEM: 7,
	cards.GNOME_PROTECTOR: 9,
	cards.MARCELLA_WHO_NURTURES_GROWTH: 2,
}


var opponent_testing_deck: Dictionary = animal_deck


var player_testing_deck: Dictionary = [
	animal_deck, magic_deck, nature_deck, robot_deck
].pick_random()
#{
	#"Cards": {
		#cards.ZALOGI_MIND_OF_MACHINES: 20,
	#},
	#"StartingCards": {
		#cards.ASSEMBLY_BOT: 1,
		#cards.FACTORY_WORKER: 1,
	#}
#}
