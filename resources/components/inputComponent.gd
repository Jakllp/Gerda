extends RefCounted

class_name InputComponent

func update(entity: Entity, delta: float) -> void:
	entity.direction = getEntitydirection()
	
func getEntitydirection() -> Vector2:
	return Vector2.ZERO
