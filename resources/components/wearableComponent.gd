extends Marker2D

class_name WearableComponent

func update(player: Player) -> void:
	assert(owner != null, "Wearables owner shouldn't be null")
	
	var mousePos := player.get_local_mouse_position()
	owner.rotation = mousePos.angle()
	owner.position = mousePos.normalized() * position.length() + player.equipment_angle_point
	
