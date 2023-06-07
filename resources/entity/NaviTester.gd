extends CharacterBody2D


const SPEED = 50

func _ready():
	var nav_map1 = get_tree().get_first_node_in_group("map").get_navigation_map(0)
	var nav_map2 = get_world_2d().navigation_map
	print("is it?  ->  ", nav_map1 == nav_map2)
	$NavigationAgent2D.set_navigation_map(nav_map2)

func _physics_process(delta):
	var target = get_tree().get_first_node_in_group("player").global_position
	$NavigationAgent2D.set_target_position(target)
	var next: Vector2 = $NavigationAgent2D.get_next_path_position()
	var rel_next = next - position
	var vel = rel_next.normalized() * SPEED
	velocity = vel
	move_and_slide()
