extends Area2D

class_name Hitbox

@export var damage: int = 0

func _on_body_entered(body):
	if body is TileMap:
		get_parent().queue_free()
