extends InputComponent

class_name EnemyInputComponent

func update(enemy: Entity) -> void:
	enemy.direction = get_enemy_direction(enemy)
	
func get_enemy_direction(enemy: Enemy) -> Vector2:
	
	var path := NavigationServer2D.map_get_path(enemy.nav_map, enemy.global_position, enemy.player.global_position, false)
	
	enemy.path = path
	
	if path.size() > 0:
		return enemy.global_position.direction_to(path[1])
	else:
		return Vector2.ZERO
