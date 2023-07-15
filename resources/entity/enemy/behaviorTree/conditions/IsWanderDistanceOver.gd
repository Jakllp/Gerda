extends BTCondition

## Check if the walked wander distacne reached the current limit

func tick(_actor:Node, blackboard:BTBlackboard):
	## Walk the path till the end when was following the player
	if blackboard.has_data("is_following_player") and blackboard.get_data("is_following_player"):
		return BTTickResult.FAILURE
	## Check if walked distance on this path is enaugh
	if blackboard.has_data("walked_distance") and blackboard.has_data("max_wander_distance"):
		if blackboard.get_data("walked_distance") > blackboard.get_data("max_wander_distance"):
			return BTTickResult.SUCCESS
	return BTTickResult.FAILURE
