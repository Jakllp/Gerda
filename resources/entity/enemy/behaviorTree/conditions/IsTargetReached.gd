extends BTCondition

func tick(actor:Node, blackboard:BTBlackboard):
	if actor.nav_agent.is_target_reached() :
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE

