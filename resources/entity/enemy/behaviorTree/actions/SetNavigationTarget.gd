extends BTAction

## Set the actors navagent target to the target stored in the blackboard

@export var target_pos_key: String

func tick(actor:Node, blackboard:BTBlackboard):
	actor.nav_agent.target_position = blackboard.get_data(target_pos_key)
	return BTTickResult.SUCCESS
