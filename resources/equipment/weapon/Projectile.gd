extends Node2D

class_name Projectile

@export var speed: int = 800
@export var range: int = 400
@export var infinite_range: bool = false
@export var pierce: int = 0

func _physics_process(delta: float) -> void:
	var distance := speed * delta
	var direction := Vector2.RIGHT.rotated(rotation)
	position += distance * direction
	
	if(not infinite_range):
		range -= distance
		if(range <= 0):
			queue_free()

func init(damage: int) -> void:
	$Hitbox.damage = damage


func _on_hitbox_body_entered(body):
	if body is TileMap:
		queue_free()
		

func _on_hitbox_area_entered(area):
	pierce -= 1
	if pierce <= 0:
		queue_free()
