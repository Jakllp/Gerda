extends Node

class_name PlayerInputComponent

func update(player: Player) -> void:
	if Input.is_action_just_pressed("LMB"):
		player.use_equipment()
		
