extends BTActionWait

## Let the enemy stay still

func tick(actor:Node, blackboard:BTBlackboard):
	if actor.sprite.is_playing():
		actor.sprite.stop()
	actor.nav_agent.target_position = actor.global_position
	return super.tick(actor, blackboard)

