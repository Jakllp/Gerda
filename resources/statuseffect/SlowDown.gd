extends StatusEffect
class_name SlowDown

## How much the speed gets affected.
var multiplier: float = 0

func _init(multiplier: float, trigger_time: float = 0, life_time: float = -1) -> void:
	super._init(trigger_time, life_time)
	self.multiplier = multiplier
	

func process(delta: float, owner) -> void:
	super.process(delta, owner)
	

## Slow the owner.
func trigger(owner) -> void:
	owner.speed *= multiplier
	
