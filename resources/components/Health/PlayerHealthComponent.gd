extends HealthComponent

func set_max_hp(value):
	super.set_max_hp(value)
	

func set_hp(value):
	super.set_hp(value)
	

func die() -> void:
	super.die()
	get_tree().change_scene_to_file("res://resources/menus/game_over_screen.tscn")
	

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if owner.has_node("Dash") and owner.dash.is_dashing(): return
	super._on_hurt_box_area_entered(area)
