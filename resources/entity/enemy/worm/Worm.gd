extends StaticEnemy
class_name Worm

@onready var shooter: ParabolicShooter = $ParabolicShooter
@onready var attack_timer: Timer = $AttackTimer
@onready var sprite: AnimatedSprite2D = $SubViewportContainer/SubViewport/AnimatedSprite2D
@onready var hurtbox = $HurtBox

func _ready() -> void:
	sprite.process_mode = Node.PROCESS_MODE_ALWAYS
	hurtbox.process_mode = Node.PROCESS_MODE_ALWAYS
	sprite.play("idle")
	super._ready()
	$AttackTimer.process_mode = Node.PROCESS_MODE_INHERIT
	

func attack() -> void:
	var pos: Vector2 = get_tree().get_first_node_in_group("player").global_position
	sprite.play("attack")
	await sprite.animation_finished
	shooter.shoot(pos)
	sprite.play("stand")
	

func activate() -> void:
	super.activate()
	hurtbox.get_child(0).shape.size.y += 17
	hurtbox.get_child(0).position.y -= 10
	sprite.play("stand")
	$PointLight2D.energy = 0.1
	

func deactivate() -> void:
	super.deactivate()
	hurtbox.get_child(0).shape.size.y -= 17
	hurtbox.get_child(0).position.y += 10
	await sprite.animation_looped
	sprite.play("idle")
	$PointLight2D.energy = 0.0

func _on_attack_timer_timeout():
	var player: Player = get_tree().get_first_node_in_group("player")
	# if no player exists
	if player == null:
		return
	if GameWorld.check_line_of_sight(self, global_position, player.global_position, 1, [self]):
		attack()
