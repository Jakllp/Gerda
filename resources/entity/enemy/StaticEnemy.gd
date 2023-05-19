extends StaticBody2D

class_name StaticEnemy

func attack() -> void:
	pass


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		attack()
