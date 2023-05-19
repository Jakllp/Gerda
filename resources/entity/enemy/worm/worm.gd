extends StaticEnemy


func attack():
	pass


func _on_attack_range_body_entered(body: Node2D):
	if body is Player:
		attack()
