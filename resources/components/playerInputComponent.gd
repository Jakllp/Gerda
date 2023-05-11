extends InputComponent

class_name PlayerInputComponent

func update(player: Entity, delta: float) -> void:
	super.update(player, delta)
	# Need to switch between weapon and mining_equipment
	if Input.is_action_just_pressed("RMB"):
		player.change_equipment(player.mining_equipment)
	if Input.is_action_just_released("RMB"):
		player.change_equipment(player.weapon)
	
	if Input.is_action_just_pressed("LMB"):
		if not Input.is_action_pressed("RMB"):
			# On left click (without right click) shoot
			player.use_equipment(delta)			
	if Input.is_action_pressed("RMB"):
		# On right-click-hold mine
		player.use_equipment(delta)
		
		
func getEntitydirection() -> Vector2:
	return Input.get_vector("left","right","up","down")
