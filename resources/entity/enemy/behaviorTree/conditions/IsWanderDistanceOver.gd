extends BTCondition

func tick(actor:Node, blackboard:BTBlackboard):
	#print(blackboard.get_data("wander_distance"))
	if blackboard.has_data("wander_distance") and blackboard.get_data("wander_distance") > actor.max_wander_distance:
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE

