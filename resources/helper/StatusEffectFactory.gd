extends Object
class_name StatusEffectFactory

## Factory class to create instances of status effects by type and with predefined values.

static func create(type: int) -> StatusEffect:
	match type:
		StatusEffectType.POISONED:
			return Poisoned.new(1, 2, 2)
		StatusEffectType.SLOW_DOWN:
			return SlowDown.new(0.5, 0, 1)
		_:
			return null
