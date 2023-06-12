extends StatusEffect
class_name Poisoned

var damage: int = 0

func _init(damage: int, trigger_time:float = 0, life_time: float = -1) -> void:
	super._init(trigger_time, life_time)
	self.damage = damage
	

func process(delta: float, owner) -> void:
	super.process(delta, owner)
	

func trigger(owner) -> void:
	(owner as Player).add_health(-1 * damage)
