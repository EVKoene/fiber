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
