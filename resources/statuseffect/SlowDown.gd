extends StatusEffect
class_name SlowDown

## How much the speed gets affected.
var multiplier: float = 0

func _init(wanted_multiplier: float, wanted_trigger_time: float = 0, wanted_life_time: float = -1) -> void:
	super._init(wanted_trigger_time, wanted_life_time)
	self.multiplier = wanted_multiplier
	

func process(delta: float, owner) -> void:
	super.process(delta, owner)
	

## Slow the owner.
func trigger(owner) -> void:
	assert(owner is Node and "speed" in owner, "SlowDown status effect connected with incompatible type")
	owner.speed *= multiplier
	
