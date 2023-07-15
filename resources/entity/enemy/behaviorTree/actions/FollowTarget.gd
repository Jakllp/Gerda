extends BTAction

## Let the enemy follow its given target by querying the next path position and setting the velocity respectivly

func tick(actor:Node, _blackboard:BTBlackboard):
	var target = actor.nav_agent.get_next_path_position()
	var velocity = (target - actor.global_position).normalized() * actor.speed
	
	if velocity.length_squared() > 0 and not actor.sprite.is_playing():
		actor.sprite.play()
	
	actor.nav_agent.set_velocity(velocity)
	return BTTickResult.RUNNING
