extends Object

## Factory class to create instances of status effects by type and with predefined values.
class_name StatusEffectFactory


static func create(type :StatusEffectType.Type) -> StatusEffect:
	match type:
		StatusEffectType.Type.POISONED:
			return Poisoned.new(1, 2, 2)
		StatusEffectType.Type.SLOW_DOWN:
			return SlowDown.new(0.5, 0, 1)
		_:
			return null
