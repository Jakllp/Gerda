extends InputComponent

class_name PlayerInputComponent

func update(player: Entity) -> void:
	player.direction = get_player_direction()
	if Input.is_action_just_pressed("LMB"):
		player.use_equipment()
		
		
func get_player_direction() -> Vector2:
	return Input.get_vector("left","right","up","down")
