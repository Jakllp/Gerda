extends StaticBody2D
class_name StaticEnemy

@onready var flash_component :FlashComponent = FlashComponent.new()

func _ready() -> void:
	$AttackRange.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_DISABLED


func attack() -> void:
	pass

func activate() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT

func deactivate() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		activate()
	

func _on_attack_range_body_exited(body):
	if body is Player:
		deactivate()
