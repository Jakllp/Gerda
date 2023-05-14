extends BTCondition

@export var refresh_timer_path: String
var timer: Timer

func tick(actor:Node, blackboard:BTBlackboard):
	if timer == null:
		timer = actor.get_node(refresh_timer_path)
	
	if timer.is_stopped():
		timer.start(timer.wait_time)
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE
