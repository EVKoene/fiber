extends Panel

class_name Costs

var animal: int
var magic: int
var nature: int
var robot: int



func _init(_animal, _magic, _nature, _robot):
	animal = _animal
	magic = _magic
	nature = _nature
	robot = _robot


func total() -> int:
	return animal + magic + nature + robot


func get_costs() -> Dictionary:
	return {
		Collections.factions.ANIMAL: animal,
		Collections.factions.MAGIC: magic,
		Collections.factions.NATURE: nature,
		Collections.factions.ROBOT: robot,
	}
