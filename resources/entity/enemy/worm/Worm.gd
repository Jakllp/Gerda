extends StaticEnemy
class_name Worm

@onready var shooter: ParabolicShooter = $ParabolicShooter

func _ready() -> void:
	super._ready()
	$AttackTimer.process_mode = Node.PROCESS_MODE_INHERIT
	
func _physics_process(delta) -> void:
	if Input.is_action_just_pressed("LMB"):
		print("Hey")

func attack() -> void:
	var pos: Vector2 = get_tree().get_first_node_in_group("player").global_position
	shooter.shoot(pos)
	

func _on_attack_timer_timeout():
	attack()
