extends CharacterBody2D

class_name MovingEnity

@export var base_speed: int = 100
var speed: int = base_speed
var direction := Vector2.ZERO:
	set(value):
		if value != direction:
			direction = value.normalized()

func _ready():
	pass
	
func _physics_process(delta):
	move()
	

func move():
	velocity = speed * direction
	move_and_slide()


func flash():
	var shader_mat = get_node("SubViewportContainer/SubViewport/AnimatedSprite2D").material
	shader_mat.set_shader_parameter("flash_modifier",0.7)
	await get_tree().create_timer(0.1).timeout
	shader_mat.set_shader_parameter("flash_modifier",0)
