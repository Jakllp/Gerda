extends Node2D

class_name Projectile

@export var speed: int = 800
@export var range: int = 400
@export var infinite_range: bool = false
	
func _physics_process(delta: float) -> void:
	var distance := speed * delta
	var direction := Vector2.RIGHT.rotated(rotation)
	position += distance * direction
	
	if(not infinite_range):
		range -= distance
		if(range <= 0):
			queue_free()
	
	if(is_out_of_bounds()):
		queue_free()

func is_out_of_bounds() -> bool:
	#TODO: implement me
	return false


func _on_hitbox_body_entered(body):
	if body is TileMap or body is MovingEnemy or body is StaticEnemy:
		queue_free()
