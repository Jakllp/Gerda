extends BTAction

@export var wander_pos_key: String
@export var wander_target_radius: int = 200
@export_flags_2d_physics var collision_mask

func tick(actor:Node, blackboard:BTBlackboard):
	var current_dir = actor.velocity.normalized() if actor.velocity != Vector2.ZERO else Vector2.RIGHT
	var random_dir = Vector2.from_angle((randf_range(0,1) - randf_range(0,1)) * PI)
	var wander_pos = actor.global_position + random_dir * wander_target_radius
	var clo = NavigationServer2D.map_get_closest_point(actor.get_world_2d().navigation_map,wander_pos)
	
#	var space_state :PhysicsDirectSpaceState2D = actor.get_world_2d().direct_space_state
#	var query = PhysicsRayQueryParameters2D.create(actor.global_position, clo)
#	query.exclude = [actor]
#	query.collision_mask = collision_mask
#	var result := space_state.intersect_ray(query)
	
	blackboard.set_data(wander_pos_key, clo)
	return BTTickResult.SUCCESS
	
