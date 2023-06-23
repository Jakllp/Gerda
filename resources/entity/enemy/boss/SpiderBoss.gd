extends StaticBody2D

@export var stomp_react_time: float = 1.5
@export var stomp_react_time_deviation: float = 0.5

@onready var player: Player = get_tree().get_first_node_in_group("player")

@onready var sweep_area: Area2D = $SweepArea
@onready var stomp_area_left: Area2D = $StompAreaLeft
@onready var stomp_area_right: Area2D = $StompAreaRight
@onready var landing_zone_left: CollisionShape2D = $LandingZoneLeft/CollisionShape2D
@onready var landing_zone_right: CollisionShape2D = $LandingZoneRight/CollisionShape2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	sprite.play("idle")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot_web() -> void:
	var player_pos = player.global_position
	$ParabolicShooter.shoot(player_pos)
	

func _on_timer_timeout():
	sprite.play("web_attack")
	await sprite.animation_finished
	shoot_web()
	sprite.play("idle")

func stomp(is_left: bool) -> void:
	var rand_pos_shift := Vector2(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))
	var target_location: Vector2
	if is_left:
		target_location = landing_zone_left.global_position + ShapeHelper.get_enclosing_box_size(landing_zone_left.shape) * rand_pos_shift
		sprite.play("stomp_left")
	else:
		target_location = landing_zone_right.global_position + ShapeHelper.get_enclosing_box_size(landing_zone_right.shape) * rand_pos_shift
		sprite.play("stomp_right")
	
	await sprite.animation_finished
	sprite.play("idle")
	var tween := create_tween()
	tween.tween_property(player, "global_position", target_location, 0.4)
	tween.parallel().tween_property(player, "scale", player.scale * 1.35, 0.2)
	tween.chain().tween_property(player, "scale", player.scale, 0.2)


func _on_stomp_area_area_entered(area, is_left):
	await get_tree().create_timer(stomp_react_time + randf_range(-stomp_react_time_deviation, stomp_react_time_deviation)).timeout
	if is_left and stomp_area_left.get_overlapping_areas().is_empty() or !is_left and stomp_area_right.get_overlapping_areas().is_empty():
		return
	
	stomp(is_left)
