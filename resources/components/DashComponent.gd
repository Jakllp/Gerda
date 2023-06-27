extends Node2D

@onready var duration_timer = $DurationTimer
@onready var refill_timer = $RefillTimer
@onready var cooldown_timer = $CooldownTimer

var color_before
var modifier_before
var affected_nodes := []

func start_dash(duration, dash_cooldown):
	if affected_nodes.size() < 1:
		for child in owner.get_children():
			if child.is_in_group("dash"):
				affected_nodes.append(child.get_child(0))
	duration_timer.wait_time = duration
	duration_timer.start()
	
	# Turn off some collisionss
	for node in affected_nodes:
		node.disabled = true
	if owner is Player:
		owner.collision_mask = 1
	
	#Flash
	owner.get_node("SubViewportContainer/SubViewport/AnimatedSprite2D").material.set_shader_parameter("flash_color", Color(1,1,1,1))
	var dash_flash_tween = self.create_tween()
	dash_flash_tween.tween_method(set_shader_value, 0.8, 0.2, duration)
	dash_flash_tween.play()
	dash_flash_tween.tween_callback(owner.flash_component.reset_shader_values.bind(owner))
	
	
	if refill_timer.is_stopped():
		refill_timer.wait_time = dash_cooldown
		refill_timer.start()


func set_shader_value(value: float):
	owner.get_node("SubViewportContainer/SubViewport/AnimatedSprite2D").material.set_shader_parameter("flash_modifier", value)


func end_dash():
	for node in affected_nodes:
		node.disabled = false
	if owner is Player:
		owner.collision_mask = 5
	cooldown_timer.start()


func is_dashing() -> bool:
	return !duration_timer.is_stopped()


# Checks if a new dash can be executed from a timing-perspective
func allowed_to_dash() -> bool:
	return cooldown_timer.is_stopped() and !is_dashing()


func stop_refill() -> void:
	refill_timer.stop()
