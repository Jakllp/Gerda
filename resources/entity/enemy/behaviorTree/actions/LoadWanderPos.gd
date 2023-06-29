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
	print("----------start load wander pos----------")
	prints("right:", rad_to_deg(Vector2.RIGHT.angle()))
	prints("up:", rad_to_deg(Vector2.UP.angle()))
	prints("left:", rad_to_deg(Vector2.LEFT.angle()))
	prints("down:", rad_to_deg(Vector2.DOWN.angle()))
	var current_dir: Vector2 = actor.velocity.normalized() if actor.velocity != Vector2.ZERO else Vector2.RIGHT
	var rand_dir = randfn(0, PI)
	var next_dir = current_dir.rotated(rand_dir)
	var max_wander_distance = blackboard.get_data("max_wander_distance")
	var actor_pos = actor.global_position
	var wander_pos = actor_pos + next_dir * randi_range(actor.min_wander_target_radius, actor.max_wander_target_radius)
	prints("current_dir:", rad_to_deg(current_dir.angle()), "  ---  ", "rand dir:", rad_to_deg(rand_dir), "  ---  ", "next dir:", rad_to_deg(next_dir.angle()))
	prints("max wander dist:", max_wander_distance, "  ---  ", "actor_pos", actor_pos, "  ---  ", "wander_pos", wander_pos)
	
	var space_state :PhysicsDirectSpaceState2D = actor.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.new()
	query.from = actor.global_position
	query.to = wander_pos
	query.exclude = [actor]
	query.collision_mask = collision_mask
	var result := space_state.intersect_ray(query)
	
	if not result.is_empty():
		prints("found result:", result.get("position"))
		var wall_distance = (result.get("position") - actor.global_position).length()
		var hold_course_prob = 2 * atan(lambda * wall_distance) / PI
		prints("wall_distance:", wall_distance, "  ---  ", "hold_prob", hold_course_prob)
		if randf() < hold_course_prob:
			wander_pos = result.get("position")
			prints("hold course with:", wander_pos)
		else:
			rand_dir = randfn(PI, PI/2)
			next_dir = current_dir.rotated(rand_dir)
			var random_pos = actor_pos + next_dir * randi_range(actor.min_wander_target_radius, actor.max_wander_target_radius)
			query.to = random_pos
			result = space_state.intersect_ray(query)
			if result.is_empty():
				wander_pos = random_pos
			else:
				wander_pos = result.get("position")
			prints("rand pos:", random_pos, "  ---  ", "wander pos:", wander_pos)
	else:
		print("no result found")
	blackboard.set_data(wander_pos_key, wander_pos)
	prints("set wander pos with:", wander_pos)
	print("----------end load wander pos----------\n")
	return BTTickResult.SUCCESS
	
func _unhandled_input(event):
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
