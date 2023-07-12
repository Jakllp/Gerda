extends StaticEnemy
class_name Worm

@onready var shooter: ParabolicShooter = $ParabolicShooter
@onready var attack_timer: Timer = $AttackTimer
@onready var sprite: AnimatedSprite2D = $SubViewportContainer/SubViewport/AnimatedSprite2D
@onready var hurtbox = $HurtBox
@onready var particle_spawner := $ParticleSpawner

func _ready() -> void:
	hurtbox.get_child(0).set_deferred("disabled", true)
	sprite.play("idle")
	super._ready()
	

func attack() -> void:
	var pos: Vector2 = get_tree().get_first_node_in_group("player").global_position
	sprite.play("attack")
	await sprite.animation_finished
	shooter.shoot(pos)
	sprite.play("stand")
	

func set_active(value: bool) -> void:
	super.set_active(value)
	if value:
		hurtbox.get_child(0).set_deferred("disabled", false)
		sprite.play("stand")
		$PointLight2D.energy = 0.1
	else:
		hurtbox.get_child(0).set_deferred("disabled", true)
		#await sprite.animation_looped
		sprite.play("idle")
		$PointLight2D.energy = 0.0

func _on_attack_timer_timeout():
	var player: Player = get_tree().get_first_node_in_group("player")
	# if not active or no player exists
	if not active or player == null:
		return
	if GameWorld.check_line_of_sight(self, global_position, player.global_position, 1):
		attack()
