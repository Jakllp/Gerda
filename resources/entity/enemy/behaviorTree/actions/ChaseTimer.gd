extends BTAction

## Time based action Node. The idea is that the enemy chases the player for a bit after he loses sight.
## The time is defined by chase_time and chase_time_deviation.

@export var chase_time: float = 4
@export var chase_time_deviation: float = 0.5

var current_time: float = 0
@onready var time_to_reach: float = randfn(chase_time, chase_time_deviation)


func tick(_actor:Node, blackboard:BTBlackboard) -> int:
	if blackboard.get_data("player_was_seen"):
		current_time += blackboard.get_delta()
		if current_time <= time_to_reach:
			return BTTickResult.SUCCESS
		
		time_to_reach = randfn(chase_time, chase_time_deviation)
		current_time = 0
		blackboard.set_data("player_was_seen", false)
	return BTTickResult.FAILURE
	

