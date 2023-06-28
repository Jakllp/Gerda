extends HealthComponent

class_name SupervisedHealthComponent

signal max_hp_changed(value)
signal hp_changed(previous, diff)

func set_max_hp(value):
	if value != hp_max:
		super.set_max_hp(value)
		max_hp_changed.emit(value)

func set_hp(value):
	var previous = hp
	super.set_hp(value)
	if previous != hp:
		hp_changed.emit(previous, hp - previous)


func _on_hurt_box_area_entered(area: Area2D) -> void:
	super._on_hurt_box_area_entered(area)
