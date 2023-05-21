extends Weapon

class_name Gun

func update(player: Player) -> void:
	for child in get_children():
		if child.has_method("update"):
			child.update(player)

func act(player: Player, delta: float) -> void:
	$Shooter.shoot()

func do_rotation(player: Player):
	$Anglepoint.aim_at_mouse_with_right_angled_grip(player)
