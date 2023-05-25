extends MovingEnemy

class_name Spider

var attack_tween: Tween

@onready var attack_range = $AttackRange/CollisionShape2D.shape.radius

func _ready() -> void:
	super._ready()


func _physics_process(delta :float) -> void:
	super._physics_process(delta)
	var sprite :AnimatedSprite2D = $SubViewportContainer/SubViewport/AnimatedSprite2D
	flip_for_movement(-1, sprite.scale.x)
	if self.direction.length() > 0:
		if !sprite.is_playing():
			sprite.play()
	elif sprite.is_playing():
		sprite.stop()


func attack() -> void:
	var jump_to: Vector2 = position + direction * attack_range
	var jump_back_to: Vector2 = position - direction * 5

	if attack_tween:
		attack_tween.kill()
	attack_tween = self.create_tween()
	attack_tween.tween_property(self, "position", jump_to, 1/attack_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	attack_tween.tween_property(self, "position", jump_back_to, attack_cooldown).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func flip() -> void:
	$SubViewportContainer/SubViewport/AnimatedSprite2D.scale.x *= -1
