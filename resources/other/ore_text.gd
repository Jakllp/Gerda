extends Node2D


func _ready():
	$DespawnTimer.start()
	# Animate Fade-In
	var in_tween = create_tween()
	in_tween.tween_property($Text, "modulate", Color(Color.WHITE,1), 0.15)
	in_tween.play()


func _process(delta):
	# Move it up a bit
	position.y -= 0.2
	


func _on_timer_timeout():
	# Animate Fade-Out
	var out_tween = create_tween()
	out_tween.tween_property($Text, "modulate", Color(Color.WHITE,0), 0.15)
	out_tween.play()
	out_tween.tween_callback(queue_free)
