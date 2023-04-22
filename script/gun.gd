extends Sprite2D

class_name Gun

@export var projectile_scene : PackedScene
@onready var projectile_spawn_point : Marker2D = $ProjectileSpawnPoint

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot() -> void:
	var projectile := projectile_scene.instantiate()
	projectile.transform = projectile_spawn_point.global_transform
	get_node("/root").add_child(projectile)
