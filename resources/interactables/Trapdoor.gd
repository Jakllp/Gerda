extends StaticBody2D

class_name Trapdoor


var open := false


func do_interaction() -> void:
	if not open:
		# Open the chest - simple enough
		open = true
		$Sprite2D.frame = 1
		$Collision.queue_free()


func _on_dropping_in_body_entered(body):
	if body is Player:
		print("BOSS-TIME!")
