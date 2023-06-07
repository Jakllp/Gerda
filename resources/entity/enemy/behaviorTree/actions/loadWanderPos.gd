extends BTAction

@export var wander_pos_key: String
@export var wander_target_radius: int = 100

func tick(actor:Node, blackboard:BTBlackboard):
	var current_dir = actor.velocity.normalized() if actor.velocity != Vector2.ZERO else Vector2.RIGHT
	var random_dir = Vector2.from_angle((randf_range(0,1) - randf_range(0,1)) * PI)
	var wander_pos = actor.global_position + random_dir * wander_target_radius
	var clo = NavigationServer2D.map_get_closest_point(actor.get_world_2d().navigation_map,wander_pos)

	blackboard.set_data(wander_pos_key, clo)
	return BTTickResult.SUCCESS
