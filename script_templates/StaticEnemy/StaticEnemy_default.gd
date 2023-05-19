# meta-description: Class template for static enemies

extends _BASE_


func attack() -> void:
	pass


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		attack()