extends Node

class_name HealthComponent

@export var hp_max: int = 0: set = set_max_hp
@export var hp: int = hp_max: set = set_hp

enum DamageType {
	BASIC,
	POISON
}


func set_max_hp(value):
	if value != hp_max:
		var difference :int
		difference = value + MutatorManager.get_modifier_for_type(Mutator.MutatorType.HEALTH_PLUS, true) - hp_max
		hp_max = value + MutatorManager.get_modifier_for_type(Mutator.MutatorType.HEALTH_PLUS, true)
		if difference > 0:
			self.hp += difference
		else:
			self.hp = hp


func set_hp(value):
	if value != hp:
		hp = clamp(value, 0, hp_max)
		if is_instance_valid(owner):
			print("Health of ", owner.name, " changed to: ", hp)
		if hp == 0:
			die()


func die() -> void:
	if owner.has_method("die"):
		# Emitting the particles is done there in that case
		owner.die()
	else:
		if "particle_spawner" in owner:
			var part_spawner :GPUParticles2D = owner.particle_spawner
			if part_spawner.emitting:
				part_spawner.emitting = false
			part_spawner.lifetime *= 1.5
			part_spawner.amount *= 2
			part_spawner.emitting = true
			owner.get_node("SubViewportContainer/SubViewport/AnimatedSprite2D").set_deferred("visible",false)
			owner.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
			await get_tree().create_timer(part_spawner.lifetime, false).timeout
		owner.queue_free()
	

func receive_damage(damage: int, damage_type := DamageType.BASIC) -> void:
	if damage == 0 or hp <= 0: return
	self.hp -= damage
	printt("damage", damage)
	owner.flash_component.flash(owner, damage_type)
	if "particle_spawner" in owner:
		if not owner.particle_spawner.emitting:
			owner.particle_spawner.emitting = true
		else:
			owner.particle_spawner.restart()


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		prints("hurtbox area entered:", area.owner, "enabled:", area.enabled)
		if area.enabled:
			if area.owner is Projectile:
				if area.owner.pierce < 1:
					area.owner.queue_free()
					if area.owner.pierce < 0:
						return
				area.owner.pierce -= 1
			receive_damage(area.damage)
