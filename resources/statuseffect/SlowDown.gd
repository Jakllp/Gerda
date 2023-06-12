extends StatusEffect
class_name SlowDown

var percentage: float = 0

func _init(percentage: float, trigger_time: float = 0, life_time: float = -1) -> void:
	super._init(trigger_time, life_time)
	self.percentage = percentage
	

func process(delta: float, owner) -> void:
	super.process(delta, owner)
	

func trigger(owner) -> void:
	owner.speed *= (1-percentage)
	
