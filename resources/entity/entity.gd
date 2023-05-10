extends CharacterBody2D

class_name Entity

@export var speed: int = 200
@export var hp_max: int = 100:
	set(value):
		if value != hp_max:
			var difference: int = value - hp_max
			hp_max = value
			if difference > 0:
				hp += difference
			else:
				self.hp = hp
@export var hp: int = hp_max:
	get:
		return hp
	set(value):
		if value != hp:
			hp = clamp(value, 0, hp_max)
			if hp == 0:
				die()

var direction: Vector2


func _physics_process(delta: float) -> void:
	move()


func move() -> void:
	velocity = speed * direction.normalized()
	move_and_slide()


func die() -> void:
	queue_free()
	


func recieve_damage(damage: int) -> void:
	self.hp -= damage


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		recieve_damage(area.damage)
