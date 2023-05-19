extends CharacterBody2D

class_name MovingEnity

@export var speed: int = 100
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
