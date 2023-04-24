extends Node2D

class_name ShooterComponent

func shoot(projectile: Projectile) -> void:
	projectile.transform = global_transform
	get_node("/root").add_child(projectile)
