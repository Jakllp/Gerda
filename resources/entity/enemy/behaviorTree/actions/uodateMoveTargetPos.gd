extends BTAction

@export var target_pos_key: String

func tick(actor:Node, blackboard:BTBlackboard):
	var path = NavigationServer2D.map_get_path(blackboard.get_data("nav_map"), actor.global_position, blackboard.get_data("player_pos"), false)
	if path.size() > 0:
		actor.path = path
		blackboard.set_data("move_path", path)
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE
