extends Node

class_name HealthComponent

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
			print("Health of ", owner.name, " changed to: ", hp)
			if hp == 0:
				die()


func die() -> void:
	owner.queue_free()
	

func recieve_damage(damage: int) -> void:
	self.hp -= damage


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		recieve_damage(area.damage)
