extends Node

class_name HealthComponent

@export var hp_max: int = 100:
	set(value):
		if value != hp_max:
			var difference: int = value - hp_max
			hp_max = value
			if difference < 0:
				hp = hp_max
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
	if owner.has_method("die"):
		owner.die()
	else:
		owner.queue_free()
	

func receive_damage(damage: int) -> void:
	if hp > 0:
		self.hp -= damage
		owner.flash_component.flash(owner)


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		if owner.has_node("Dash") and owner.dash.is_dashing(): return
		if area.owner is Projectile: 
			if area.owner.pierce < 1:
				area.owner.queue_free()
				if area.owner.pierce < 0:
					return
			area.owner.pierce -= 1
		receive_damage(area.damage)
