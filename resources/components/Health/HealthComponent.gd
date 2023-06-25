extends Node

class_name HealthComponent

@export var hp_max: int = 6: set = set_max_hp
@export var hp: int = hp_max: set = set_hp


func set_max_hp(value):
	if value != hp_max:
		var difference: int = value - hp_max
		hp_max = value
		if difference > 0:
			hp += difference
		else:
			self.hp = hp


func set_hp(value):
	if value != hp:
		hp = clamp(value, 0, hp_max)
		print("Health of ", owner.name, " changed to: ", hp)
		if hp == 0:
			die()


func die() -> void:
	owner.queue_free()
	

func receive_damage(damage: int) -> void:
	if damage == 0: return
	self.hp -= damage
	owner.flash_component.flash(owner)


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		if area.owner is Projectile: 
			if area.owner.pierce < 1:
				area.owner.queue_free()
				if area.owner.pierce < 0:
					return
			area.owner.pierce -= 1
		receive_damage(area.damage)