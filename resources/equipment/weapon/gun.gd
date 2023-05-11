extends Weapon

class_name Gun

@export var projectile_scene :PackedScene

func update(player: Player) -> void:
	for child in get_children():
		if child.has_method("update"):
			child.update(player)
			

func act(player: Player, delta: float) -> void:
	$Shooter.shoot(projectile_scene.instantiate())
