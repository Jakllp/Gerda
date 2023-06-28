extends MovingEnemy

class_name Spider

var attack_tween: Tween

@onready var attack_range_shape = $AttackRange/CollisionShape2D.shape
@onready var hitbox_shape = $Hitbox/CollisionShape2D.shape
@onready var attack_range_radius = ShapeHelper.get_shape_radius($AttackRange/CollisionShape2D.shape)
@onready var hitbox_shape_radius = ShapeHelper.get_shape_radius($Hitbox/CollisionShape2D.shape)

func _ready() -> void:
	super._ready()


func _physics_process(delta :float) -> void:
	super._physics_process(delta)


func attack() -> void:
	if not GameWorld.check_line_of_sight(self, global_position, get_tree().get_first_node_in_group("player").global_position, 1):
		return
	if not attack_tween:
		sprite.stop()
		
		attack_range_shape.radius = 0.0
		hitbox_shape.radius = hitbox_shape_radius
		
		var direction = velocity.normalized()
		var jump_to: Vector2 = position + direction * attack_range_radius
		var jump_back_to: Vector2 = position - direction * 5
		
		attack_tween = self.create_tween()
		attack_tween.tween_property(self, "position", jump_to, 1/attack_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		attack_tween.tween_property(self, "position", jump_back_to, attack_cooldown).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		attack_tween.tween_callback(stop_attack)


func stop_attack() -> void:
	sprite.play()
	attack_tween = null
	attack_range_shape.radius = attack_range_radius
	hitbox_shape.radius = 0.0
