extends BTCondition

func tick(actor:Node, blackboard:BTBlackboard):
	if blackboard.has_data("walked_distance") and blackboard.has_data("max_wander_distance"):
		if blackboard.get_data("walked_distance") > blackboard.get_data("max_wander_distance"):
			return BTTickResult.SUCCESS
	return BTTickResult.FAILURE

