extends Area2D

var containing_bodies: Array


## Puts the poisoned status effect on the body inside
func apply_effect(body) -> void:
	body.status_effects.add(StatusEffectType.Type.POISONED)
	body.flash_component.standard_color = Color(0.0955,0.9045,0.0,1)
	body.flash_component.standard_modifier = 0.2
	body.flash_component.reset_shader_values(body)
		


func _on_area_entered(area):
	## If this body is capable of bearing status effects, register him to get effected by this area.
	if "status_effects" in area.owner:
		containing_bodies.append(area.owner)
		apply_effect(area.owner)
		$TriggerTimer.start()


func _on_area_exited(area):
	## unregister the leaving area.
	containing_bodies.erase(area.owner)
	if containing_bodies.size() == 0:
		$TriggerTimer.stop()


func _on_life_time_timeout():
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color("ffffff", 0), 1.5)
	tween.tween_callback(queue_free)


func _on_trigger_timer_timeout():
	for body in containing_bodies:
		apply_effect(body)
	

