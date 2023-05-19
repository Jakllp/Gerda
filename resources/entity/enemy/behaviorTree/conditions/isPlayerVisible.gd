extends BTCondition

@export var player_pos_key: String

func tick(actor:Node, blackboard:BTBlackboard):
	var player_pos = blackboard.get_data(player_pos_key)
	if player_pos == null:
		return BTTickResult.FAILURE
		
	var space_state :PhysicsDirectSpaceState2D = actor.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(actor.global_position, player_pos)
	query.exclude = [actor]
	query.collision_mask = 0b10000000_00000000_00000000_00000001
	var result := space_state.intersect_ray(query)
	if result.is_empty():
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE
