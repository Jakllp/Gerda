extends RefCounted

class_name PlayerInputComponent


func update(player: Player, delta: float) -> void:
	player.direction = get_player_direction()
	check_for_equip_switch(player)
	check_for_equip_use(player, delta)
	check_dash(player)


func get_player_direction() -> Vector2:
	return Input.get_vector("left","right","up","down")


# Checks if we need to switch between equipments (and also triggers that switch)
func check_for_equip_switch(player: Player) -> void:
	if Input.is_action_just_pressed("RMB"):
		player.change_equipment(player.mining_equipment)
	if Input.is_action_just_released("RMB"):
		player.change_equipment(player.weapon)


# Checks if we need to use the equipment (and also triggers the equip-use)
func check_for_equip_use(player: Player, delta: float) -> void:
	if Input.is_action_just_pressed("LMB") or Input.is_action_pressed("RMB"):
		player.use_equipment(delta)


# Dashes
func check_dash(player: Player) -> void:
	if Input.is_action_just_pressed("dash"):
		player.try_dash()
