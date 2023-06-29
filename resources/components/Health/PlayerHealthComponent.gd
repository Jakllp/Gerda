extends SupervisedHealthComponent


func set_max_hp(value):
	if value != hp_max:
		var difference :int = value - hp_max
		hp_max = value
		if difference > 0:
			self.hp += difference
		else:
			self.hp = hp
		max_hp_changed.emit(value)


func receive_damage(damage: int) -> void:
	super.receive_damage(damage + MutatorManager.get_modifier_for_type(Mutator.MutatorType.DAMAGE_PLUS, true))


func _on_hurt_box_area_entered(area: Area2D) -> void:
	super._on_hurt_box_area_entered(area)
