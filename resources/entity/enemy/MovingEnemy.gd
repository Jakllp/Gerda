extends CharacterBody2D

class_name MovingEnemy

## speed of the enemy
@export var speed: int = 60
## For melee attacks the time it takes to execute the actual attack
## For ranged attacks the velocity of the projectile
@export var attack_speed: float
## The time between succesive attacks
@export var attack_cooldown: float
## The minimum radius for selecting a wander position
@export var min_wander_target_radius: int = 100
## The maximum radius for selecting a wander position
@export var max_wander_target_radius: int = 200
## The maximum distance this enemy walks on the same wander path
@export var max_wander_distance: int = 200
## How much the max_wander_distance can vary
@export var wander_distance_deviation: int = 100

@onready var sprite :AnimatedSprite2D = $SubViewportContainer/SubViewport/AnimatedSprite2D
@onready var nav_agent:NavigationAgent2D = $NavigationAgent2D
@onready var flash_component :FlashComponent = FlashComponent.new()

func _ready() -> void:
	sprite.play()
	nav_agent.radius = ShapeHelper.get_shape_radius($CollisionShape2D.shape)
	$BTBlackboard.set_data("walked_distance", 0)

func _physics_process(delta: float) -> void:
	pass
	

func attack() -> void:
	pass
	

func flip() -> void:
	# TODO: It's ugly. Should flip whole enemy -> But something flips it back.
	$SubViewportContainer/SubViewport/AnimatedSprite2D.scale.x *= -1


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body is Player:
		attack()
	

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	if safe_velocity.sign().x == $SubViewportContainer/SubViewport/AnimatedSprite2D.scale.x:
		flip()
	move_and_slide()
