extends StaticBody2D
class_name SpiderBoss

@export var stomp_react_time: float = 1.5
@export var stomp_react_time_deviation: float = 0.5
@export var sweep_react_time: float = 1.5
@export var sweep_react_time_deviation: float = 0.5

@export var lackey_scene: PackedScene

@onready var player: Player = get_tree().get_first_node_in_group("player")

@onready var animation_tree :AnimationTree = $AnimationTree

@onready var shooter: ParabolicShooter = $ParabolicShooter
@onready var sweep_area: Area2D = $SweepArea
@onready var stomp_area_left: Area2D = $StompAreaLeft
@onready var stomp_area_right: Area2D = $StompAreaRight
@onready var landing_zone_left: CollisionShape2D = $LandingZoneLeft/CollisionShape2D
@onready var landing_zone_right: CollisionShape2D = $LandingZoneRight/CollisionShape2D
@onready var stomp_particles_left: GPUParticles2D = $StompParticlesLeft
@onready var stomp_particles_right: GPUParticles2D = $StompParticlesRight

@onready var flash_component :FlashComponent = FlashComponent.new()

signal died

func _ready():
	$SubViewportContainer/SubViewport/AnimatedSprite2D.material.set_shader_parameter("flash_modifier",0)
	animation_tree.active = true
	$LegLeft.damage = 1
	$LegRight.damage = 1
	$HitboxAndBody.damage = 1
	$SupervisedHealthComponent.max_hp_changed.emit($SupervisedHealthComponent.hp_max)

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		$SupervisedHealthComponent.hp -= 1
	

func shoot_web() -> void:
	shooter.shoot(player.global_position)
	

func stomp_left() -> void:
	player.get_node("Camera2D").apply_noise_screen_shake(100.0, 3.0, 1.5, 30.0)
	stomp_particles_left.emitting = true
	if stomp_area_left.get_overlapping_areas().is_empty():
		return
	var rand_pos_shift := Vector2(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))
	var target_location: Vector2 = landing_zone_left.global_position + ShapeHelper.get_enclosing_box_size(landing_zone_left.shape) * rand_pos_shift
	yeet_player(target_location)
	

func stomp_right() -> void:
	player.get_node("Camera2D").apply_noise_screen_shake(100.0, 3.0, 1.5, 30.0)
	stomp_particles_right.emitting = true
	if stomp_area_right.get_overlapping_areas().is_empty():
		return
	var rand_pos_shift := Vector2(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))
	var target_location: Vector2 = landing_zone_right.global_position + ShapeHelper.get_enclosing_box_size(landing_zone_right.shape) * rand_pos_shift
	yeet_player(target_location)
	

func yeet_player(target_location: Vector2) -> void:
	var tween := create_tween()
	tween.tween_property(player, "global_position", target_location, 0.4)
	tween.parallel().tween_property(player, "scale", player.scale * 1.35, 0.2)
	tween.chain().tween_property(player, "scale", player.scale, 0.2)


func sweep() -> void:
	if not sweep_area.get_overlapping_areas().is_empty():
		animation_tree["parameters/conditions/sweep"] = true
		get_tree().create_timer(sweep_react_time + randf_range(-sweep_react_time_deviation, sweep_react_time_deviation)).timeout.connect(sweep)
	else:
		animation_tree["parameters/conditions/sweep"] = false
		

func spawn_lackey() -> void:
	var point = get_tree().get_nodes_in_group("spawn_points").pick_random()
	var lackey = lackey_scene.instantiate()
	lackey.global_position = point.global_position
	
	var tween: Tween = create_tween()
	tween.tween_property(point, "modulate", Color(0,0,0,1), 2)
	
	await tween.finished
	get_parent().add_child(lackey)
	point.modulate = Color(0,0,0,0)
	


func die() -> void:
	animation_tree["parameters/conditions/dead"] = true
	
	# No more damage - this is the easiest way
	$LegLeft.damage = 0
	$LegRight.damage = 0
	$HitboxAndBody.damage = 0
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 2)
	tween.tween_callback(queue_free)
	await tween.finished
	died.emit()
	

func _on_stomp_area_area_entered(_area, is_left):
	# wait for reaction
	await get_tree().create_timer(stomp_react_time + randf_range(-stomp_react_time_deviation, stomp_react_time_deviation)).timeout
	if is_left and stomp_area_left.get_overlapping_areas().is_empty() or !is_left and stomp_area_right.get_overlapping_areas().is_empty():
		return
	if is_left:
		animation_tree["parameters/conditions/stomp_left"] = true
	else:
		animation_tree["parameters/conditions/stomp_right"] = true
	

func _on_stomp_area_area_exited(_area, is_left):
	if is_left:
		animation_tree["parameters/conditions/stomp_left"] = false
	else:
		animation_tree["parameters/conditions/stomp_right"] = false
		

func _on_shoot_timer_timeout():
	animation_tree["parameters/conditions/shoot"] = true


func _on_spawn_timer_timeout():
	spawn_lackey()


func _on_sweep_area_area_entered(_area):
	# wait for reaction
	get_tree().create_timer(sweep_react_time + randf_range(-sweep_react_time_deviation, sweep_react_time_deviation)).timeout.connect(sweep)
	

func _on_sweep_area_area_exited(_area):
	animation_tree["parameters/conditions/sweep"] = false


