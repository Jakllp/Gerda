extends CharacterBody2D


var speed = 70
@onready var nav_agent = $NavigationAgent2D

func _ready():
	nav_agent.radius = $Area2D/CollisionShape2D.shape.radius
	

func _physics_process(delta):
	var player_pos = get_tree().get_first_node_in_group("player").global_position
	nav_agent.target_position = player_pos
	var target = nav_agent.get_next_path_position()
	var vel = global_position.direction_to(player_pos) * speed
	nav_agent.set_velocity(vel)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
