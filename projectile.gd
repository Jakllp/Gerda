extends Area2D

class_name Projectile

@export var Speed: int = 600

func _physics_process(delta: float) -> void:
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += Speed * direction * delta
