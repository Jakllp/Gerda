extends Node2D

@onready var duration_timer = $DurationTimer
@onready var refill_timer = $RefillTimer

func start_dash(duration, dash_refill_speed):
	duration_timer.wait_time = duration
	duration_timer.start()
	if refill_timer.is_stopped():
		refill_timer.wait_time = dash_refill_speed
		refill_timer.start()


func is_dashing() -> bool:
	return !duration_timer.is_stopped()


func stop_refill() -> void:
	refill_timer.stop()
