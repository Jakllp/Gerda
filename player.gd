extends CharacterBody2D

@export var speed := 500.0
@export var projectile_scene : PackedScene
@onready var projectile_spawn_point : Marker2D = $Gun/Marker2D
@onready var gun := $Gun


func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	velocity = speed * Input.get_vector("left","right","up","down")
	move_and_slide()
	if Input.is_action_just_pressed("shoot"):
		shoot()
	

func _process(delta: float) -> void:
	var mousePos := get_local_mouse_position()
	gun.rotation = mousePos.angle()
	gun.position = mousePos.normalized() * $Environment_collision.shape.get_rect().size.x/2
	return
	

func shoot() -> void:
	var projectile :Projectile = projectile_scene.instantiate()
	projectile.transform = projectile_spawn_point.global_transform
	owner.add_child(projectile)
	
	
