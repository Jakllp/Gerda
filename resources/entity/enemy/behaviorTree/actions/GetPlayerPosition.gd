extends BTAction

@export var player_pos_key: String
@export var player_group_name: String

func tick(actor:Node, blackboard:BTBlackboard):
	if actor.get_tree().has_group(player_group_name):
		blackboard.set_data(player_pos_key, actor.get_tree().get_first_node_in_group(player_group_name).global_position)
		return BTTickResult.SUCCESS
	else:
		return BTTickResult.FAILURE

