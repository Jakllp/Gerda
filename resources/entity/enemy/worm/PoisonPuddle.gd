extends Area2D

var containing_bodies: Array


## Puts the poisoned status effect on the body inside
func apply_effect(body) -> void:
	body.status_effects.add(StatusEffectType.POISONED)

## If this body is capable of bearing status effects, register him to get effected by this area.
func _on_body_entered(body):
	if "status_effects" in body:
		containing_bodies.append(body)
		apply_effect(body)
		$TriggerTimer.start()


func _on_body_exited(body):
	containing_bodies.erase(body)
	if containing_bodies.size() == 0:
		$TriggerTimer.stop()


func _on_life_time_timeout():
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color("ffffff", 0), 1.5)
	tween.tween_callback(queue_free)


func _on_trigger_timer_timeout():
	for body in containing_bodies:
		apply_effect(body)
	

