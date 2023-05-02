extends InputComponent

class_name PlayerInputComponent

func update(player: Entity) -> void:
	super.update(player)
	if Input.is_action_just_pressed("LMB"):
		player.use_equipment()
		
		
func getEntitydirection() -> Vector2:
	return Input.get_vector("left","right","up","down")
