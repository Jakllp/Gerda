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
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass
#	print("body: " + str(body))
#	print(str(get_last_slide_collision()))
#	if body is TileMap:
#		print("is TTileMap" + "\n")


func _unhandled_input(event: InputEvent) -> void:
	#mining stuff
	if event.is_action("LMB"):
		get_viewport().set_input_as_handled()
		var collision :RayCast2D = $Gun/RayCast2D
		print("Colliding with: " + str(collision.get_collider()))
		if collision.is_colliding() and collision.get_collider() is TileMap:
			var point := collision.get_collision_point()
			print("point" + str(point))
			var map :TileMap = collision.get_collider()
			
			var scale := map.scale
			print("scale: " + str(scale))
			point /= map.scale
			
			var normal = collision.get_collision_normal()
			print("normal: " + str(normal))
			point -= normal
			
			print("point modified: " + str(point))
			
			var point2 = map.local_to_map(point)
			print(point2)
			print("\n")
			map.erase_cell(1, point2)
			map.set_cell(0, point2, 0, Vector2i(0,0), 0)
