extends StatusEffect
class_name Poisoned

## Damage per trigger
var damage: int = 0

func _init(damage: int, trigger_time:float = 0, life_time: float = -1) -> void:
	super._init(trigger_time, life_time)
	self.damage = damage
	

func process(delta: float, owner) -> void:
	super.process(delta, owner)
	

## Damage the owner
func trigger(owner) -> void:
	assert(owner is Node and owner.has_node("PlayerHealthComponent"), "Poisoned status effect connected with incompatible type")
	owner.get_node("PlayerHealthComponent").receive_damage(damage)
