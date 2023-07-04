extends StaticBody2D

class_name Trapdoor



func do_interaction() -> void:
	# Open the chest - simple enough
	$Sprite2D.frame = 1
	$Collision.queue_free()
	$Collision2.disabled = false
	$DroppingIn/CollisionShape2D.disabled = false


func _on_dropping_in_body_entered(body):
	get_node("/root/Main/GameWorld").proceed_level()
