extends SupervisedHealthComponent


func set_max_hp(value):
	if value != hp_max:
		var difference :int
		difference = value - hp_max
		hp_max = value
		if difference > 0:
			self.hp += difference
		else:
			self.hp = hp
		max_hp_changed.emit(value)

func set_hp(value):
	var previous = hp
	super.set_hp(value)
	if previous != hp:
		hp_changed.emit(previous, hp - previous)


func receive_damage(damage: int) -> void:
	super.receive_damage(damage + MutatorManager.get_modifier_for_type(Mutator.MutatorType.DAMAGE_PLUS, true))


func _on_hurt_box_area_entered(area: Area2D) -> void:
	super._on_hurt_box_area_entered(area)
