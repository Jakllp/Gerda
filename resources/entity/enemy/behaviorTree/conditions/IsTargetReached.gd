extends BTCondition

func tick(actor:Node, blackboard:BTBlackboard):
	if actor.nav_agent.is_target_reached() or actor.nav_agent.target_position == Vector2.ZERO:
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE

