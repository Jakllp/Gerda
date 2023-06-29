extends BTCondition

func tick(actor:Node, blackboard:BTBlackboard):
	#prints("target dist:", actor.nav_agent.distance_to_target(), " final pos:", actor.nav_agent.get_final_position(), " next papos:", actor.nav_agent.get_next_path_position(), " fin?", actor.nav_agent.is_navigation_finished(), " rea?", actor.nav_agent.is_target_reached())
	if actor.nav_agent.is_navigation_finished():
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE

