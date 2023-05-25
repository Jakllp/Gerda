extends Gun

class_name Rifle


func act(player: Player, delta: float) -> void:
	if mag_contents >= ammo_needed_per_shot and reload_timer.is_stopped():
		$Shooter.shoot()
		mag_contents -= ammo_needed_per_shot
		print("Shot! "+str(mag_contents)+"/"+str(ammo_stored))
		
		# Trigger reload if mag is now too low
		if mag_contents < ammo_needed_per_shot:
			trigger_reload()

func reload() -> void:
	super.reload()
