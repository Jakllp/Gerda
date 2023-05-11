extends InputComponent

class_name PlayerInputComponent

func update(player: Entity, delta: float) -> void:
	super.update(player, delta)
	if Input.is_action_just_pressed("LMB"):
		if not Input.is_action_pressed("RMB"):
			player.use_equipment(delta)			
	if Input.is_action_pressed("RMB"):
		player.try_mine(delta)
		
		
func getEntitydirection() -> Vector2:
	return Input.get_vector("left","right","up","down")
