extends InputComponent

class_name EnemyInputComponent


func update(entity: Entity) -> void:
	entity.direction = getEntitydirection()
	
func getEntitydirection() -> Vector2:
	return Vector2.ZERO
