extends Object
class_name StatusEffectFactory

static func create(type: int) -> StatusEffect:
	match type:
		StatusEffectTypes.POISONED:
			return Poisoned.new(2, 4, 1)
		StatusEffectTypes.SLOW_DOWN:
			return SlowDown.new(0.5)
		_:
			return null
