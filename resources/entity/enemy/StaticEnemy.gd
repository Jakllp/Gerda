extends StaticBody2D

class_name StaticEnemy

@onready var flash_component :FlashComponent = FlashComponent.new()


func attack() -> void:
	pass


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		attack()
