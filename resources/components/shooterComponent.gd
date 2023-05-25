extends Node2D

class_name ShooterComponent

@export var projectile_scene :PackedScene


func _ready():
	position = Vector2(position.x-0.5,position.y-0.5)


func shoot() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.transform = global_transform
	get_node("/root").add_child(projectile)
