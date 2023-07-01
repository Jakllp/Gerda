extends BTAction

## The way it works:
## When selecting the next position to wander to the actor will firstly try to hold his current direction.
## Therefor he looks ahead (distance defined in blackboard as "max_wander_distance") if there is anything he can see (defined by collision_mask).
## If there is nothing he keeps going. In case there is something (typically a wall) the distance is calculated (wall_distance).
## Afterwards a propability for holding his course is calculated. This probability is depends on the wall_distance.
## With great distance comes great probability ;)
## Then the dice will be rolled and the actor has the calculated chance to stay on course.
## If he doesn't he takes a point with random direction and a random distance (in the range of actor.min_wander_target_radius, actor.max_wander_target_radius).
## He tries multiple times (defined by point_tries) to take a point in 180 degree radius infrint of him.
## In case he fils every time he just takes the last point.

## Key to store the wander position in the blackboard
@export var wander_pos_key: String
## Defines what the actor can see (which collision layer)
@export_flags_2d_physics var collision_mask
## Amount of attempts to take a random point infront
const point_tries = 10
## Varible to influence the probability distribution
const lambda = 0.005

func tick(actor:Node, blackboard:BTBlackboard):
	prints("nav cell size:", NavigationServer2D.map_get_cell_size(actor.get_world_2d().navigation_map))
	var current_dir: Vector2 = actor.velocity.normalized() if actor.velocity != Vector2.ZERO else Vector2.RIGHT
	var next_dir = current_dir.rotated(randfn(0, PI))
	var wander_pos = actor.global_position + next_dir * randi_range(actor.min_wander_target_radius, actor.max_wander_target_radius)


	blackboard.set_data(wander_pos_key, wander_pos)
	return BTTickResult.SUCCESS
	
