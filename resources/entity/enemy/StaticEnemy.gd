extends StaticBody2D
class_name StaticEnemy

var flash_component :FlashComponent = FlashComponent.new()
var active = false : set = set_active

func _ready() -> void:
	$Hitbox.damage = 1
	

func set_active(value: bool) -> void:
	active = value
	

func attack() -> void:
	pass


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		active = true
	

func _on_attack_range_body_exited(body):
	if body is Player:
		active = false
