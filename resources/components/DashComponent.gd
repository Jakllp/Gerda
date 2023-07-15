extends Node2D

@onready var duration_timer :Timer = $DurationTimer
@onready var refill_timer :Timer = $RefillTimer
@onready var cooldown_timer :Timer = $CooldownTimer

var current_refill_time
var affected_nodes := []

## Handles the actual dash-timings and parts of the visuals
func start_dash(duration, dash_refill):
	if affected_nodes.size() < 1:
		for child in owner.get_children():
			if child.is_in_group("dash"):
				affected_nodes.append(child.get_child(0))
	
	if !refill_timer.is_stopped():
		refill_timer.paused = true
	current_refill_time = dash_refill
	
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


## Sets the flash-modifier
func set_shader_value(value: float):
	owner.get_node("SubViewportContainer/SubViewport/AnimatedSprite2D").material.set_shader_parameter("flash_modifier", value)


## Ends the dash, starts the cooldown-timer and refill-timer (or unpauses the latter if already running)
func end_dash():
	for node in affected_nodes:
		node.disabled = false
	if owner is Player:
		owner.collision_mask = 5
	cooldown_timer.start()
	
	if refill_timer.paused:
		refill_timer.paused = false
	elif refill_timer.is_stopped():
		refill_timer.wait_time = current_refill_time
		refill_timer.start()


func is_dashing() -> bool:
	return !duration_timer.is_stopped()


## Checks if a new dash can be executed from a timing-perspective
func allowed_to_dash() -> bool:
	return cooldown_timer.is_stopped() and !is_dashing()


## Called in between refills if there are multiple. Checks if the refill-speed was changed 
func update_refill(dash_refill) -> void:
	if current_refill_time > dash_refill:
		current_refill_time = dash_refill
		refill_timer.wait_time = dash_refill


func stop_refill() -> void:
	refill_timer.stop()
