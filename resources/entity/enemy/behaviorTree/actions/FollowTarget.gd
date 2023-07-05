extends BTAction

@export var path_index_key: String
@export var move_path_key: String
@export var point_reached_margin: int
var flag = true

func tick(actor:Node, _blackboard:BTBlackboard):
	var target = actor.nav_agent.get_next_path_position()
	var velocity = (target - actor.global_position).normalized() * actor.speed
	
	if velocity.length_squared() > 0 and not actor.sprite.is_playing():
		actor.sprite.play()
	
	actor.nav_agent.set_velocity(velocity)
	return BTTickResult.RUNNING
