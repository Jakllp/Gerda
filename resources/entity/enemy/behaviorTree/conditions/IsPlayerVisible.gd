extends BTCondition

@export var player_pos_key: String
@export_flags_2d_physics var collision_mask

func tick(actor:Node, blackboard:BTBlackboard):
	var player_pos = blackboard.get_data(player_pos_key)
	# if no player exists
	if player_pos == null:
		return BTTickResult.FAILURE
	
	if GameWorld.check_line_of_sight(actor, actor.global_position, player_pos, collision_mask, [actor]):
		blackboard.set_data("player_was_seen", true)
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE
