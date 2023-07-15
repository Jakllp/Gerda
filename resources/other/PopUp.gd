extends Node2D


func _ready():
	$DespawnTimer.start()
	# Animate Fade-In
	var in_tween = create_tween()
	if get_node_or_null("Label") != null:
		in_tween.parallel().tween_property($Label, "modulate", Color(Color.WHITE,1), 0.15)
	if get_node_or_null("Icon") != null:
		in_tween.parallel().tween_property($Icon, "modulate", Color(Color.WHITE,1), 0.15)
	in_tween.play()


func _process(_delta):
	# Move it up a bit
	position.y -= 0.2


func _on_timer_timeout():
	# Animate Fade-Out
	var out_tween = create_tween()
	if get_node_or_null("Label") != null:
		out_tween.parallel().tween_property($Label, "modulate", Color(Color.WHITE,0), 0.15)
	if get_node_or_null("Icon") != null:
		out_tween.parallel().tween_property($Icon, "modulate", Color(Color.WHITE,0), 0.15)
	out_tween.play()
	out_tween.tween_callback(queue_free)
