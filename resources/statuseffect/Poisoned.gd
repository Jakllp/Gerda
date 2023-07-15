extends StatusEffect
class_name Poisoned

## Damage per trigger
var damage: int = 0

func _init(wanted_damage: int, wanted_trigger_time:float = 0, wanted_life_time: float = -1) -> void:
	super._init(wanted_trigger_time, wanted_life_time)
	self.damage = wanted_damage
	

func process(delta: float, owner) -> void:
	super.process(delta, owner)
	

## Damage the owner
func trigger(owner) -> void:
	assert(owner is Node and owner.has_node("PlayerHealthComponent"), "Poisoned status effect connected with incompatible type")
	owner.get_node("PlayerHealthComponent").receive_damage(damage, HealthComponent.DamageType.POISON)
	prints(owner, "receieved poison damage")


## Disable
func disable(owner) -> void:
	owner.flash_component.standard_flash_color = Color(1,1,1,1)
	owner.flash_component.standard_modifier = 0.0
	
	if owner is Player:
		owner.flash_component.standard_vignette_enabled = false
		owner.flash_component.standard_vignette_softness = 3.0
		owner.flash_component.standard_vignette_color = Color(1.0,0.0,0.0,1.0)
	owner.flash_component.reset_shader_values(owner)
