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
	await sprite.frame_changed
	shooter.shoot(pos)
	sprite.play("stand")
	

func activate() -> void:
	super.activate()
	hurtbox.get_child(0).shape.size.y += 17
	hurtbox.get_child(0).position.y -= 10
	sprite.play("stand")
	

func deactivate() -> void:
	super.deactivate()
	hurtbox.get_child(0).shape.size.y -= 17
	hurtbox.get_child(0).position.y += 10
	await sprite.animation_looped
	sprite.play("idle")

func check_line_of_sight() -> bool:
	var player = get_tree().get_first_node_in_group("player")
	# if no player exists
	if player == null:
		return false
	
	var player_pos = player.global_position
	
	# prepare and execute raycast
	var space_state :PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player_pos)
	query.exclude = [self]
	query.collision_mask = 1
	var result := space_state.intersect_ray(query)
	# if nothing was in the way there is a line of sight
	if result.is_empty():
		return true
	else:
		return false

func _on_attack_timer_timeout():
	if check_line_of_sight():
		attack()
