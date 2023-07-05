extends Gun

class_name Rifle


func act(_player: Player, _delta: float) -> void:
	if mag_contents >= ammo_needed_per_shot and reload_timer.is_stopped() and fire_rate_timer.is_stopped():
		var damage_plus = damage_upgrade_modifier * active_upgrades[Items.Type.DAMAGE]
		$Shooter.shoot(base_damage + damage_plus)
		
		mag_contents -= ammo_needed_per_shot
		
		# Trigger reload if mag is now too low
		if mag_contents < ammo_needed_per_shot:
			trigger_reload()
		else:
			var fire_delay = base_fire_delay - (base_fire_delay * fire_delay_upgrade_modifier/100) * active_upgrades[Items.Type.ATTACK_RATE]
			fire_rate_timer.wait_time = fire_delay
			fire_rate_timer.start()
