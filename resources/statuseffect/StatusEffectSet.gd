extends RefCounted
class_name StatusEffectSet

var owner
var effects: Dictionary

func _init(owner):
	self.owner = owner

func process(delta: float):
	for type in effects:
		effects[type].process(delta, owner)
		if effects[type].passed_life_time > effects[type].life_time and effects[type].life_time > 0:
			effects.erase(type)

func add(type: int) -> bool:
	if effects.has(type):
		effects[type].refresh()
		return false
	else:
		effects[type] = StatusEffectFactory.create(type)
		return true

