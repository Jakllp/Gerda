extends StaticBody2D

class_name Trapdoor


var open := false


func do_interaction() -> void:
	if not open:
		# Open the chest - simple enough
		open = true
		$Sprite2D.frame = 1
		$Collision.queue_free()
		$Collision2.disabled = false
	else:
		if Input.is_action_just_pressed("interact"):
			get_node("/root/Main/GameWorld").proceed_level()

