extends Weapon

class_name Gun

func update(player: Player) -> void:
	for child in get_children():
		if child.has_method("update"):
			child.update(player)
			

func act(player: Player) -> void:
	$Shooter.shoot(player.projectile_scene.instantiate())
