extends RefCounted
class_name StatusEffectSet

## A container for storing and processign status effects. Effects are stored in a dictionary
## with the corresponding StatusEffecType as key.

var owner
var effects: Dictionary

func _init(wanted_owner):
	self.owner = wanted_owner
	

## Process all of the status effects with the current delta time and their owner.
## If a effect's lifetime is over it will be deleted
func process(delta: float):
	for type in effects:
		effects[type].process(delta, owner)
		if effects[type].is_life_time_over():
			erase(type)
	

## Add a new status effect if its type doesn't already exist (return true). Otherwise the effect will be refreshed (return false).
func add(type :StatusEffectType.Type) -> bool:
	if effects.has(type):
		effects[type].refresh()
		return false
	else:
		effects[type] = StatusEffectFactory.create(type)
		return true


## Erase a status effect.
func erase(type: StatusEffectType.Type) -> bool:
	effects[type].disable(self.owner)
	return effects.erase(type)
