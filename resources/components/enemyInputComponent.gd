extends InputComponent

class_name EnemyInputComponent

func update(enemy: Entity) -> void:
	enemy.direction = get_enemy_direction(enemy)
	
func get_enemy_direction(enemy: Enemy) -> Vector2:
	
	var path := NavigationServer2D.map_get_path(enemy.nav_map, enemy.global_position, enemy.player.global_position, false)
	
	return path[1]
