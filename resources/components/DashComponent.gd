extends Node2D

@onready var duration_timer = $DurationTimer
@onready var refill_timer = $RefillTimer
@onready var cooldown_timer = $CooldownTimer


func start_dash(duration, dash_cooldown):
	duration_timer.wait_time = duration
	duration_timer.start()
	if refill_timer.is_stopped():
		refill_timer.wait_time = dash_cooldown
		refill_timer.start()


func end_dash():
	cooldown_timer.start()


func is_dashing() -> bool:
	return !duration_timer.is_stopped()


# Checks if a new dash can be executed from a timing-perspective
func allowed_to_dash() -> bool:
	return cooldown_timer.is_stopped() and !is_dashing()


func stop_refill() -> void:
	refill_timer.stop()
