extends Node2D

class_name ShooterComponent

@export var projectile_scene :PackedScene

func shoot() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.transform = global_transform
	get_node("/root").add_child(projectile)
