extends CharacterBody2D

class_name MovingEnemy

## speed of the enemy
@export var speed: int = 70
## For melee attacks the time it takes to execute the actual attack
## For ranged attacks the velocity of the projectile
@export var attack_speed: float
##the time between succesive attacks
@export var attack_cooldown: float

@onready var sprite :AnimatedSprite2D = $SubViewportContainer/SubViewport/AnimatedSprite2D
@onready var nav_agent:NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	sprite.play()
	nav_agent.radius = ShapeHelper.get_shape_radius($CollisionShape2D.shape)
	

func _physics_process(delta: float) -> void:
	pass
	

func attack() -> void:
	pass
	

func flip() -> void:
	# TODO: It's ugly. Should flip whole enemy -> But something flips it back.
	$SubViewportContainer/SubViewport/AnimatedSprite2D.scale.x *= -1
	

func flash():
	var shader_mat = get_node("SubViewportContainer/SubViewport/AnimatedSprite2D").material
	shader_mat.set_shader_parameter("flash_modifier",0.4)
	await get_tree().create_timer(0.05).timeout
	shader_mat.set_shader_parameter("flash_modifier",0)
	

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		attack()
	

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	if safe_velocity.sign().x == $SubViewportContainer/SubViewport/AnimatedSprite2D.scale.x:
		flip()
	move_and_slide()
