extends HealthComponent

signal max_hp_changed(value)
signal hp_changed(previos, diff)

func set_max_hp(value):
	super.set_max_hp(value)
	max_hp_changed.emit(value)

func set_hp(value):
	hp_changed.emit(hp, value - hp)
	super.set_hp(value)
	

func die() -> void:
	super.die()
	get_tree().change_scene_to_file("res://resources/menus/GameOverScreen.tscn")
	

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if owner.has_node("Dash") and owner.dash.is_dashing(): return
	super._on_hurt_box_area_entered(area)
